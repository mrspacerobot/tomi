import CoreGraphics
import XCTest

extension XCUIScreenshot {
    /// A small colour sample of the visible character stage catches a blank RealityKit surface.
    var tomatoCoverage: Double {
        var pixels = [UInt8](repeating: 0, count: 32 * 32 * 4)
        let context = CGContext(
            data: &pixels,
            width: 32,
            height: 32,
            bitsPerComponent: 8,
            bytesPerRow: 128,
            space: CGColorSpace(name: CGColorSpace.sRGB)!,
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        )!
        context.draw(image.cgImage!, in: CGRect(x: 0, y: 0, width: 32, height: 32))
        let redPixels = stride(from: 0, to: pixels.count, by: 4).filter {
            Double(pixels[$0]) > Double(pixels[$0 + 1]) * 1.5 && pixels[$0] > pixels[$0 + 2] && pixels[$0] > 80
        }
        return Double(redPixels.count) / 1024
    }
}
