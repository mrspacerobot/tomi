import CoreGraphics
import XCTest

extension XCUIScreenshot {
    /// How bright the ground of the screen is, from 0 (black) to 1 (white).
    /// Read from one pixel in the left margin, a quarter of the way down, where no screen draws anything.
    var groundBrightness: Double {
        let screen = image.cgImage!
        let margin = CGRect(x: screen.width / 40, y: screen.height / 4, width: 1, height: 1)
        var parts = [UInt8](repeating: 0, count: 4)
        let context = CGContext(
            data: &parts,
            width: 1,
            height: 1,
            bitsPerComponent: 8,
            bytesPerRow: 4,
            space: CGColorSpace(name: CGColorSpace.sRGB)!,
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        )!
        context.draw(screen.cropping(to: margin)!, in: CGRect(x: 0, y: 0, width: 1, height: 1))
        return (Double(parts[0]) + Double(parts[1]) + Double(parts[2])) / (3 * 255)
    }
}
