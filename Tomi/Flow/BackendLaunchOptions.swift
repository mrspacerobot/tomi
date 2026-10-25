import Foundation

/// What the launch arguments say about the server. UI tests, the shared schemes and `scripts/run.sh` pass them;
/// a cook never does, so a plain launch talks to the deployed server.
nonisolated struct BackendLaunchOptions: Equatable {
    /// Run against the in-memory fake server and fake sign-in, with a fixed photo instead of the camera.
    static let fakeBackendArgument = "--fake-backend"
    /// Show Apple’s native button over fake services to test its real layout.
    static let appleSignInButtonArgument = "--apple-sign-in-button"
    /// Talk to the server running on this Mac instead of the deployed one, with the real sign-in.
    static let localBackendArgument = "--local-backend"
    /// The fake server suggests nothing tonight, as the real one does before the cook has reached a lesson's level.
    static let fakeNoSuggestionsArgument = "--fake-no-suggestions"
    static let fakeGuidedArgument = "--fake-guided-cooking"
    static let fakeProfileRefreshFailsArgument = "--fake-profile-refresh-fails"
    static let fakeProfileRefreshChangesArgument = "--fake-profile-refresh-changes"
    static let fakeProfileRefreshWaitsArgument = "--fake-profile-refresh-waits"
    /// The fake cook is already signed in.
    static let fakeSignedInArgument = "--fake-signed-in"

    /// The fake cook saved an avoid item the fake lists do not name, as a newer server could have.
    static let fakeUnlistedAvoidArgument = "--fake-unlisted-avoid"

    let usesFake: Bool
    let showsAppleSignInButton: Bool
    let usesLocalAPI: Bool
    let suggestionsNothing: Bool
    let guidedCooking: Bool
    let profileRefreshFails: Bool
    let profileRefreshChanges: Bool
    let profileRefreshWaits: Bool
    let startsSignedIn: Bool
    let savedUnlistedAvoid: Bool

    init(arguments: [String]) {
        usesFake = arguments.contains(Self.fakeBackendArgument)
        showsAppleSignInButton = arguments.contains(Self.appleSignInButtonArgument)
        usesLocalAPI = arguments.contains(Self.localBackendArgument)
        suggestionsNothing = arguments.contains(Self.fakeNoSuggestionsArgument)
        guidedCooking = arguments.contains(Self.fakeGuidedArgument)
        profileRefreshFails = arguments.contains(Self.fakeProfileRefreshFailsArgument)
        profileRefreshChanges = arguments.contains(Self.fakeProfileRefreshChangesArgument)
        profileRefreshWaits = arguments.contains(Self.fakeProfileRefreshWaitsArgument)
        startsSignedIn = arguments.contains(Self.fakeSignedInArgument)
        savedUnlistedAvoid = arguments.contains(Self.fakeUnlistedAvoidArgument)
    }
}
