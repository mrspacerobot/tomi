import CoreGraphics
import ImageIO
import SwiftUI
import UniformTypeIdentifiers

@testable import Tomi

/// The app icon of one appearance, rendered from the same drawing as Tomi in the app.
///
/// SwiftUI draws it into a Core Graphics bitmap made here, on the CPU, rather than through `cgImage`, whose
/// GPU rasterising once gave back an all-black icon while the simulator was busy with UI tests.
@MainActor enum RenderedAppIcon {
    static func image(_ appearance: AppIconAppearance) -> CGImage? {
        let side = AppIconFraming.side
        let artwork = AppIconArtwork(appearance: appearance).frame(width: side, height: side)
        let renderer = ImageRenderer(content: artwork)
        var image: CGImage?
        renderer.render { _, draw in
            let context = bitmap(side: Int(side))
            draw(context)
            image = context.makeImage()
        }
        return image
    }

    /// Writes the icon as a PNG, which is what the asset catalog takes.
    static func write(_ image: CGImage, to url: URL) -> Bool {
        let type = UTType.png.identifier as CFString
        guard let destination = CGImageDestinationCreateWithURL(url as CFURL, type, 1, nil) else { return false }
        CGImageDestinationAddImage(destination, image, nil)
        return CGImageDestinationFinalize(destination)
    }

    /// Opaque sRGB, eight bits a channel: an app icon has no transparency.
    private static func bitmap(side: Int) -> CGContext {
        CGContext(
            data: nil,
            width: side,
            height: side,
            bitsPerComponent: 8,
            bytesPerRow: 0,
            space: CGColorSpace(name: CGColorSpace.sRGB)!,
            bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue
        )!
    }
}
