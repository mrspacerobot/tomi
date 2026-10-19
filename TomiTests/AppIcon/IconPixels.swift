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

    /// The share of pixels where some channel differs by more than `tolerance`.
    func differingShare(from other: IconPixels, tolerance: Int) -> Double {
        var differing = 0
        for pixel in stride(from: 0, to: bytes.count, by: 4) where differs(other, at: pixel, by: tolerance) {
            differing += 1
        }
        return Double(differing) / Double(width * height)
    }

    private func differs(_ other: IconPixels, at pixel: Int, by tolerance: Int) -> Bool {
        (0..<3).contains { channel in
            abs(Int(bytes[pixel + channel]) - Int(other.bytes[pixel + channel])) > tolerance
        }
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
