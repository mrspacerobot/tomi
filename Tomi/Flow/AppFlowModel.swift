import Foundation
import OSLog
import TomiCore

/// The order of the app: sign in, the first questions, then home. Each screen reports back here.
@Observable
final class AppFlowModel {
    private static let logger = Logger(category: .backend)

    private(set) var stage = AppStage.starting
    private(set) var problem: ProblemText?
    let services: AppServices
    let profile: ProfileModel
    /// Sends the cooks saved on this phone to the server, by itself.
    let uploader: CookEntryUploader

    init(services: AppServices) {
        self.services = services
        profile = ProfileModel(api: services.api, store: services.store)
        uploader = CookEntryUploader(api: services.api, store: services.store, clock: .phone)
    }

    func start() async {
        guard await services.auth.isSignedIn() else {
            stage = .signedOut
            return
        }
        await loadProfile()
    }

    func signIn(with identity: AppleIdentity) async {
        do {
            try await services.auth.signIn(with: identity)
            await loadProfile()
        } catch {
            report(error)
            stage = .signedOut
        }
    }

    func signIn(email: String, password: String) async throws {
        try await services.auth.signIn(email: email, password: password)
        await loadProfile()
    }

    func createAccount(email: String, password: String) async throws -> SignUpResult {
        let result = try await services.auth.createAccount(email: email, password: password)
        if result == .authenticated {
            await loadProfile()
        }
        return result
    }

    func sendPasswordReset(to email: String) async throws {
        try await services.auth.sendPasswordReset(to: email)
    }

    /// The app came back to the screen: cooks saved offline may go now. Only a signed-in cook's cooks are sent.
    func appBecameActive() {
        if stage == .home || stage == .onboarding {
            uploader.upload()
        }
    }

    func finishOnboarding() {
        stage = .home
    }

    func signOut() async {
        try? await services.auth.signOut()
        stage = .signedOut
    }

    private func loadProfile() async {
        do {
            try await profile.load()
            showLoadedProfile()
        } catch BackendError.notSignedIn {
            stage = .signedOut
        } catch {
            report(error)
            stage = .failed
        }
    }

    /// The cook is signed in and their answers are here, so the cooks saved on the phone can go to the server.
    private func showLoadedProfile() {
        problem = nil
        stage = stageAfterLoading
        uploader.upload()
    }

    private var stageAfterLoading: AppStage {
        if profile.profile.isOnboardingDone {
            return .home
        }
        return .onboarding
    }

    private func report(_ error: any Error) {
        Self.logger.error("A call failed: \(String(describing: error), privacy: .public)")
        problem = ProblemText(error)
    }
}
