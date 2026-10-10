import Foundation

/// The services one launch runs on: Tomi's server, sign-in, the lessons on the phone, the store and the camera.
/// A UI test launch swaps the server, sign-in and camera for fakes (`BackendLaunchOptions`).
struct AppServices {
    let api: any TomiAPI
    let auth: any AuthService
    let library: any LessonLibrary
    let store: any ProgressStore
    let photos: PhotoSource

    /// Fakes over the given library and store, for previews and tests.
    static func fake(library: any LessonLibrary, store: any ProgressStore) -> AppServices {
        AppServices(
            api: FakeTomiAPI(library: library),
            auth: FakeAuthService(),
            library: library,
            store: store,
            photos: .fixed(PhotoSource.fakePhoto)
        )
    }
}
