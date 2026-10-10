import Foundation

/// What the launch arguments say about the server. UI tests pass them, a cook never does.
nonisolated struct BackendLaunchOptions: Equatable {
    /// Run against the in-memory fake server and fake sign-in, with a fixed photo instead of the camera.
    static let fakeBackendArgument = "--fake-backend"
    /// The fake server offers nothing tonight, as the real one does before the cook has reached a lesson's level.
    static let fakeNoSpecialsArgument = "--fake-no-specials"
    /// The fake cook is already signed in.
    static let fakeSignedInArgument = "--fake-signed-in"

    let usesFake: Bool
    let offersNothing: Bool
    let startsSignedIn: Bool

    init(arguments: [String]) {
        usesFake = arguments.contains(Self.fakeBackendArgument)
        offersNothing = arguments.contains(Self.fakeNoSpecialsArgument)
        startsSignedIn = arguments.contains(Self.fakeSignedInArgument)
    }
}
