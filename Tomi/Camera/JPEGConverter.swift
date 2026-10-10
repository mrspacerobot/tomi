import Foundation
import ImageIO
import UniformTypeIdentifiers

/// Turns any photo the phone can read, HEIC included, into a JPEG the server accepts: at most `largestSide`
/// pixels on its long side and under the server's 10 MB. The copy carries no metadata, so no place or time
/// leaves the phone with it.
nonisolated enum JPEGConverter {
    static let largestSide = 2_048
    static let quality = 0.8
    static let largestBytes = 10_000_000

    static func jpeg(from photo: Data) throws -> Data {
        guard let source = CGImageSourceCreateWithData(photo as CFData, nil) else {
            throw JPEGConversionError.unreadable
        }
        guard let image = CGImageSourceCreateThumbnailAtIndex(source, 0, thumbnailOptions) else {
            throw JPEGConversionError.unreadable
        }
        return try encoded(image)
    }

    private static var thumbnailOptions: CFDictionary {
        [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceThumbnailMaxPixelSize: largestSide,
        ] as CFDictionary
    }

    private static func encoded(_ image: CGImage) throws -> Data {
        let output = NSMutableData()
        let type = UTType.jpeg.identifier as CFString
        guard let destination = CGImageDestinationCreateWithData(output, type, 1, nil) else {
            throw JPEGConversionError.unreadable
        }
        let options = [kCGImageDestinationLossyCompressionQuality: quality] as CFDictionary
        CGImageDestinationAddImage(destination, image, options)
        guard CGImageDestinationFinalize(destination), output.length < largestBytes else {
            throw JPEGConversionError.tooLarge
        }
        return output as Data
    }
}
