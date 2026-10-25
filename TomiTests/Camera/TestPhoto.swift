import CoreGraphics
import Foundation
import ImageIO
import UniformTypeIdentifiers

/// A small JPEG with a place and a time in it, as a phone writes them, to feed the converter.
enum TestPhoto {
    static let latitude = 47.3769
    static let takenAt = "2026:10:13 12:00:00"

    static func make(width: Int = 64, height: Int = 48, orientation: Int = 1) -> Data {
        let output = NSMutableData()
        let type = UTType.jpeg.identifier as CFString
        let destination = CGImageDestinationCreateWithData(output, type, 1, nil)!
        CGImageDestinationAddImage(destination, solidImage(width: width, height: height), properties(orientation))
        CGImageDestinationFinalize(destination)
        return output as Data
    }

    /// What the file says about itself, ImageIO's way: a dictionary of dictionaries.
    static func properties(of jpeg: Data) -> [CFString: Any] {
        let source = CGImageSourceCreateWithData(jpeg as CFData, nil)!
        let properties = CGImageSourceCopyPropertiesAtIndex(source, 0, nil)
        return (properties as? [CFString: Any]) ?? [:]
    }

    private static func solidImage(width: Int, height: Int) -> CGImage {
        let context = bitmapContext(width: width, height: height)
        context.setFillColor(red: 0.8, green: 0.2, blue: 0.1, alpha: 1)
        context.fill(CGRect(x: 0, y: 0, width: width, height: height))
        return context.makeImage()!
    }

    private static func bitmapContext(width: Int, height: Int) -> CGContext {
        CGContext(
            data: nil,
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: 0,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue
        )!
    }

    private static func properties(_ orientation: Int) -> CFDictionary {
        let time: [CFString: Any] = [kCGImagePropertyExifDateTimeOriginal: takenAt]
        return [
            kCGImagePropertyGPSDictionary: place, kCGImagePropertyExifDictionary: time,
            kCGImagePropertyOrientation: orientation,
        ] as CFDictionary
    }

    private static var place: [CFString: Any] {
        [
            kCGImagePropertyGPSLatitude: latitude, kCGImagePropertyGPSLatitudeRef: "N",
            kCGImagePropertyGPSLongitude: 8.5417, kCGImagePropertyGPSLongitudeRef: "E",
        ]
    }
}
