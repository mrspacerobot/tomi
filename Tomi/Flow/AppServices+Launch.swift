import Foundation
import OSLog
import TomiCore

extension AppServices {
    /// The services the launch arguments ask for, or nil when this build has no server configured.
    static func forLaunch(_ options: BackendLaunchOptions, store: any ProgressStore) -> AppServices? {
        if options.usesFake {
            return fakeForUITests(options, store: store)
        }
        guard let configuration = BackendConfiguration.read(for: options) else {
            return nil
        }
        return live(configuration, store: store)
    }

    private static func fakeForUITests(
        _ options: BackendLaunchOptions,
        store: any ProgressStore
    ) -> AppServices {
        let profile = fakeProfile(options, store: store)
        return AppServices(
            api: fakeAPI(fakeServer(options, store: store), profile: profile),
            auth: fakeAuth(options),
            store: store,
            photos: .fixed(PhotoSource.fakePhoto),
            usesFakeSignInButton: !options.showsAppleSignInButton,
            dishPhotos: .fake
        )
    }

    private static func fakeAuth(_ options: BackendLaunchOptions) -> FakeAuthService {
        FakeAuthService(
            signedIn: options.startsSignedIn,
            account: options.fakeAccount,
            rejectsPassword: options.fakeRejectsPassword
        )
    }

    private static func fakeAPI(
        _ configuration: FakeTomiAPIConfiguration,
        profile: CookProfile,
    ) -> any TomiAPI {
        FakeTomiAPI(
            profile: profile,
            configuration: configuration
        )
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
        store: any ProgressStore
    ) -> AppServices {
        let backend = liveBackend(configuration)
        return AppServices(
            api: backend.api,
            auth: backend.auth,
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
