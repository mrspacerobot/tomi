import Foundation

/// The services one launch runs on: Tomi's server, sign-in, the store and the camera.
/// A UI test launch swaps the server, sign-in and camera for fakes (`BackendLaunchOptions`).
struct AppServices {
    let api: any TomiAPI
    let auth: any AuthService
    let store: any ProgressStore
    let photos: PhotoSource
    let usesFakeSignInButton: Bool

    /// Fakes over the given store, for previews and tests.
    static func fake(store: any ProgressStore, signedIn: Bool = false) -> AppServices {
        AppServices(
            api: FakeTomiAPI(),
            auth: FakeAuthService(signedIn: signedIn),
            store: store,
            photos: .fixed(PhotoSource.fakePhoto),
            usesFakeSignInButton: true
        )
    }
}
