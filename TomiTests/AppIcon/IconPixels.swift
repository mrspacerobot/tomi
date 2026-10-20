import CoreGraphics
import Foundation
import ImageIO

/// An icon read back as plain sRGB bytes, four to a pixel, so two icons can be compared and a pixel looked at.
struct IconPixels {
    let width: Int
    let height: Int
    let bytes: [UInt8]

    init(_ image: CGImage) {
        width = image.width
        height = image.height
        var buffer = [UInt8](repeating: 0, count: image.width * image.height * 4)
        buffer.withUnsafeMutableBytes { raw in
            let context = Self.context(raw.baseAddress!, width: image.width, height: image.height)
            context.draw(image, in: CGRect(x: 0, y: 0, width: image.width, height: image.height))
        }
        bytes = buffer
    }

    init?(contentsOf url: URL) {
        guard let source = CGImageSourceCreateWithURL(url as CFURL, nil) else { return nil }
        guard let image = CGImageSourceCreateImageAtIndex(source, 0, nil) else { return nil }
        self.init(image)
    }

    /// Red, green and blue of the pixel at a point measured from the top left.
    func rgb(at point: CGPoint) -> [Int] {
        let start = (Int(point.y) * width + Int(point.x)) * 4
        return bytes[start..<start + 3].map { Int($0) }
    }

    /// How many pixels differ in any channel, by even one level.
    func differingPixels(from other: IconPixels) -> Int {
        var differing = 0
        for pixel in stride(from: 0, to: bytes.count, by: 4)
        where bytes[pixel..<pixel + 3] != other.bytes[pixel..<pixel + 3] {
            differing += 1
        }
        return differing
    }

    private static func context(_ data: UnsafeMutableRawPointer, width: Int, height: Int) -> CGContext {
        CGContext(
            data: data,
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: width * 4,
            space: CGColorSpace(name: CGColorSpace.sRGB)!,
            bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue
        )!
    }
}
