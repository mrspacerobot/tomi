import Foundation

/// Where the fridge photo comes from: the cook's photos, or a fixed photo for UI tests, which never use a camera.
enum PhotoSource {
    /// Synthetic QA photo. The fake server uses fixture matches for every photo.
    static var fakePhoto: Data {
        guard let url = Bundle.main.url(forResource: "fake-fridge-photo", withExtension: "jpg"),
            let jpeg = try? Data(contentsOf: url)
        else { return Data() }
        return jpeg
    }

    case photoLibrary
    case fixed(Data)
}
