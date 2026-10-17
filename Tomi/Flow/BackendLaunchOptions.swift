import Foundation

/// What the launch arguments say about the server. UI tests pass them, a cook never does.
nonisolated struct BackendLaunchOptions: Equatable {
    /// Run against the in-memory fake server and fake sign-in, with a fixed photo instead of the camera.
    static let fakeBackendArgument = "--fake-backend"
    /// Show Apple’s native button over fake services to test its real layout.
    static let appleSignInButtonArgument = "--apple-sign-in-button"
    /// The fake server offers nothing tonight, as the real one does before the cook has reached a lesson's level.
    static let fakeNoSpecialsArgument = "--fake-no-specials"
    /// The fake cook is already signed in.
    static let fakeSignedInArgument = "--fake-signed-in"

    /// The fake cook saved an avoid item the fake lists do not name, as a newer server could have.
    static let fakeUnlistedAvoidArgument = "--fake-unlisted-avoid"

    let usesFake: Bool
    let showsAppleSignInButton: Bool
    let offersNothing: Bool
    let startsSignedIn: Bool
    let savedUnlistedAvoid: Bool

    init(arguments: [String]) {
        usesFake = arguments.contains(Self.fakeBackendArgument)
        showsAppleSignInButton = arguments.contains(Self.appleSignInButtonArgument)
        offersNothing = arguments.contains(Self.fakeNoSpecialsArgument)
        startsSignedIn = arguments.contains(Self.fakeSignedInArgument)
        savedUnlistedAvoid = arguments.contains(Self.fakeUnlistedAvoidArgument)
    }
}
