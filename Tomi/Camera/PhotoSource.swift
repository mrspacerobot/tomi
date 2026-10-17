import Foundation

/// Where the fridge photo comes from: the cook's photos, or a fixed photo for UI tests, which never use a camera.
enum PhotoSource {
    /// Stands in for a JPEG in fake launches. The fake server never reads it.
    static let fakePhoto = Data([0xFF, 0xD8, 0xFF, 0xD9])

    case photoLibrary
    case fixed(Data)
}
