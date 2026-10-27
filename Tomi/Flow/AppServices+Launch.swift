import Foundation
import OSLog
import TomiCore

extension AppServices {
    /// The services the launch arguments ask for, or nil when this build has no server configured.
    static func forLaunch(_ options: BackendLaunchOptions, store: any ProgressStore) -> AppServices? {
        let library = BundledLessonLibrary()
        if options.usesFake {
            return fakeForUITests(options, library: library, store: store)
        }
        guard let configuration = BackendConfiguration.read(for: options) else {
            return nil
        }
        return live(configuration, library: library, store: store)
    }

    private static func fakeForUITests(
        _ options: BackendLaunchOptions,
        library: any LessonLibrary,
        store: any ProgressStore
    ) -> AppServices {
        let profile = fakeProfile(options, store: store)
        return AppServices(
            api: fakeAPI(options, profile: profile, library: library),
            auth: FakeAuthService(signedIn: options.startsSignedIn),
            library: library,
            store: store,
            photos: .fixed(PhotoSource.fakePhoto),
            usesFakeSignInButton: !options.showsAppleSignInButton
        )
    }

    private static func fakeAPI(
        _ options: BackendLaunchOptions,
        profile: CookProfile,
        library: any LessonLibrary
    ) -> any TomiAPI {
        FakeTomiAPI(
            library: library,
            profile: profile,
            configuration: fakeAPIConfiguration(options)
        )
    }

    private static func fakeAPIConfiguration(_ options: BackendLaunchOptions) -> FakeTomiAPIConfiguration {
        FakeTomiAPIConfiguration(
            suggestionsNothing: options.suggestionsNothing,
            guidedCooking: options.guidedCooking,
            profileRefreshFails: options.profileRefresh.fails,
            profileRefreshChanges: options.profileRefresh.changes,
            profileRefreshWaits: options.profileRefresh.waits,
            quiz: fakeQuiz(options),
            quizOffline: options.quiz.isOffline
        )
    }

    /// The invented quiz the launch handed over, or none when there is none or it cannot be read.
    private static func fakeQuiz(_ options: BackendLaunchOptions) -> FakeQuiz? {
        guard let text = options.quiz.fixture else {
            return nil
        }
        do {
            return try FakeQuiz.decode(from: text)
        } catch {
            Logger(category: .backend).error("The fake quiz handed over at launch cannot be read.")
            return nil
        }
    }

    /// A cook who starts signed in has been here before: the fake server holds the answers saved on the phone,
    /// so a seeded store shows the same progress after the profile is fetched.
    private static func fakeProfile(_ options: BackendLaunchOptions, store: any ProgressStore) -> CookProfile {
        guard options.startsSignedIn, var profile = try? store.profile() else {
            return CookProfile()
        }
        profile.isOnboardingDone = true
        if options.savedUnlistedAvoid {
            profile.avoid.insert(FakeOptions.unlistedSavedItem)
        }
        return profile
    }

    private static func live(
        _ configuration: BackendConfiguration,
        library: any LessonLibrary,
        store: any ProgressStore
    ) -> AppServices {
        let backend = liveBackend(configuration)
        return AppServices(
            api: backend.api,
            auth: backend.auth,
            library: library,
            store: store,
            photos: .photoLibrary,
            usesFakeSignInButton: false
        )
    }

    private static func liveBackend(
        _ configuration: BackendConfiguration
    ) -> (api: any TomiAPI, auth: any AuthService) {
        let transport = URLSessionTransport()
        let tokens = SupabaseTokenClient(
            supabaseURL: configuration.supabaseURL,
            publishableKey: configuration.publishableKey,
            transport: transport
        )
        let auth = SupabaseAuthService(client: tokens, store: KeychainTokenStore(), now: { Date.now })
        let client = APIClient(baseURL: configuration.apiBaseURL, auth: auth, transport: transport)
        return (URLSessionTomiAPI(client: client), auth)
    }
}
