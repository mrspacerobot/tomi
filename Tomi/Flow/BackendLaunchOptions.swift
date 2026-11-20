import Foundation

/// What the launch arguments say about the server. UI tests, the shared schemes and `scripts/run.sh` pass them;
/// a cook never does, so a plain launch talks to the deployed server.
nonisolated struct BackendLaunchOptions: Equatable {
    /// Run against the in-memory fake server and fake sign-in, with a fixed photo instead of the camera.
    static let fakeOptionsUnavailableArgument = "--fake-options-unavailable"
    static let fakeRejectsPasswordArgument = "--fake-rejects-password"
    static let fakeBackendArgument = "--fake-backend"
    /// Show Apple’s native button over fake services to test its real layout.
    static let appleSignInButtonArgument = "--apple-sign-in-button"
    /// Talk to the server running on this Mac instead of the deployed one, with the real sign-in.
    static let localBackendArgument = "--local-backend"
    /// The fake server suggests nothing tonight, as the real one does before the cook has reached a lesson's level.
    static let fakeNoSuggestionsArgument = "--fake-no-suggestions"
    static let fakeGuidedArgument = "--fake-guided-cooking"
    /// The fake server's progress is that of a new cook, as it is without an argument.
    static let fakeProgressNewCookArgument = "--fake-progress-new-cook"
    /// The fake server's progress is that of a cook who has cooked before.
    static let fakeProgressReturningArgument = "--fake-progress-returning"
    /// The fake server's progress routes fail as if the phone were offline.
    static let fakeCookEntriesOfflineArgument = "--fake-cook-entries-offline"
    /// The fake cook is already signed in.
    static let fakeSignedInArgument = "--fake-signed-in"
    /// Use a second fake account to exercise account changes without a real sign-in.
    static let fakeOtherAccountArgument = "--fake-other-account"

    /// The fake cook saved an avoid item the fake lists do not name, as a newer server could have.
    static let fakeUnlistedAvoidArgument = "--fake-unlisted-avoid"
    /// The fake server's suggestions carry a dish photo, served from the app bundle (`FakeDishPhoto`).
    static let fakeDishPhotosArgument = "--fake-dish-photos"

    let fakeRejectsPassword: Bool
    let usesFake: Bool
    let showsAppleSignInButton: Bool
    let usesLocalAPI: Bool
    /// How the fake server behaves, when it is used.
    let fakeServer: FakeTomiAPIConfiguration
    let startsSignedIn: Bool
    let usesOtherAccount: Bool
    let savedUnlistedAvoid: Bool
    let quiz: FakeQuizOptions

    init(arguments: [String]) {
        fakeRejectsPassword = arguments.contains(Self.fakeRejectsPasswordArgument)
        usesFake = arguments.contains(Self.fakeBackendArgument)
        showsAppleSignInButton = arguments.contains(Self.appleSignInButtonArgument)
        usesLocalAPI = arguments.contains(Self.localBackendArgument)
        fakeServer = FakeTomiAPIConfiguration(arguments: arguments)
        startsSignedIn = arguments.contains(Self.fakeSignedInArgument)
        usesOtherAccount = arguments.contains(Self.fakeOtherAccountArgument)
        savedUnlistedAvoid = arguments.contains(Self.fakeUnlistedAvoidArgument)
        quiz = FakeQuizOptions(arguments: arguments)
    }
}
