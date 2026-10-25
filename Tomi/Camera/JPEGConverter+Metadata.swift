import Foundation
import ImageIO

nonisolated extension JPEGConverter {
    /// The photo's own properties (place, time, camera) made to fit the shrunken picture.
    static func properties(of source: CGImageSource) -> [CFString: Any] {
        guard var all = CGImageSourceCopyPropertiesAtIndex(source, 0, nil) as? [CFString: Any] else {
            return [:]
        }
        for key in staleAfterResizing {
            all[key] = nil
        }
        removeStaleDetails(from: &all)
        return all
    }

    /// The shrunken picture is already turned upright and has its own size, so the original's no longer apply.
    private static var staleAfterResizing: [CFString] {
        [kCGImagePropertyOrientation, kCGImagePropertyPixelWidth, kCGImagePropertyPixelHeight]
    }

    private static var staleDetails: [(dictionary: CFString, keys: [CFString])] {
        [
            (kCGImagePropertyTIFFDictionary, [kCGImagePropertyTIFFOrientation]),
            (
                kCGImagePropertyExifDictionary,
                [kCGImagePropertyExifPixelXDimension, kCGImagePropertyExifPixelYDimension]
            ),
        ]
    }

    private static func removeStaleDetails(from properties: inout [CFString: Any]) {
        for (dictionary, keys) in staleDetails {
            guard var details = properties[dictionary] as? [CFString: Any] else {
                continue
            }
            for key in keys {
                details[key] = nil
            }
            properties[dictionary] = details
        }
    }
}
