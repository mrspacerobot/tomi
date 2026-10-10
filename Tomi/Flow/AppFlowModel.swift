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

    init(services: AppServices) {
        self.services = services
        profile = ProfileModel(api: services.api, store: services.store)
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
            problem = nil
            stage = stageAfterLoading
        } catch BackendError.notSignedIn {
            stage = .signedOut
        } catch {
            report(error)
            stage = .failed
        }
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
