import Foundation
import ImageIO
import UniformTypeIdentifiers

/// Turns any photo the phone can read, HEIC included, into a small JPEG the server accepts: at most `largestSide`
/// pixels on its long side, compressed to `quality`, and under the server's 10 MB. It carries the photo's own place,
/// time and camera details: proof of concept, the server keeps every photo as it arrived.
nonisolated enum JPEGConverter {
    static let largestSide = 1_280
    static let quality = 0.6
    static let largestBytes = 10_000_000

    static func jpeg(from photo: Data) throws -> Data {
        guard let source = CGImageSourceCreateWithData(photo as CFData, nil) else {
            throw JPEGConversionError.unreadable
        }
        guard let image = CGImageSourceCreateThumbnailAtIndex(source, 0, thumbnailOptions) else {
            throw JPEGConversionError.unreadable
        }
        let metadata = properties(of: source)
        return try encoded(image, with: metadata)
    }

    private static var thumbnailOptions: CFDictionary {
        [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceThumbnailMaxPixelSize: largestSide,
        ] as CFDictionary
    }

    private static func encoded(_ image: CGImage, with metadata: [CFString: Any]) throws -> Data {
        let output = NSMutableData()
        let destination = try jpegDestination(writingInto: output)
        var options = metadata
        options[kCGImageDestinationLossyCompressionQuality] = quality
        CGImageDestinationAddImage(destination, image, options as CFDictionary)
        guard CGImageDestinationFinalize(destination), output.length < largestBytes else {
            throw JPEGConversionError.tooLarge
        }
        return output as Data
    }

    private static func jpegDestination(writingInto output: NSMutableData) throws -> CGImageDestination {
        let type = UTType.jpeg.identifier as CFString
        guard let destination = CGImageDestinationCreateWithData(output, type, 1, nil) else {
            throw JPEGConversionError.unreadable
        }
        return destination
    }
}
