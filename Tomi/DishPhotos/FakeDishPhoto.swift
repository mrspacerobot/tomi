import Foundation

/// The dish photo the fake server names when a launch asks for photos (`--fake-dish-photos`). Its address is on a
/// host that does not exist, and `FakeDishPhotoProtocol` answers it from the app bundle, so it shows without the
/// network. The picture is a Codex-generated plate of the fake special, seared chicken with a pan sauce.
nonisolated enum FakeDishPhoto {
    static let host = "dish-photos.fake.invalid"
    static let address = "https://\(host)/fake-dish-photo.webp"

    /// The photo's bytes from the bundle, or nil when the file is missing.
    static func data() -> Data? {
        guard let url = Bundle.main.url(forResource: "fake-dish-photo", withExtension: "webp") else {
            return nil
        }
        return try? Data(contentsOf: url)
    }
}
