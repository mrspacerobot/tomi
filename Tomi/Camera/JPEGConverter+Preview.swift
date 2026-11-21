import Foundation
import ImageIO

nonisolated extension JPEGConverter {
    static func preview(from jpeg: Data) -> CGImage? {
        guard let source = CGImageSourceCreateWithData(jpeg as CFData, nil) else { return nil }
        return CGImageSourceCreateImageAtIndex(source, 0, nil)
    }
}
