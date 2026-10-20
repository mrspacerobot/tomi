import CoreGraphics
import Testing

@testable import Tomi

/// The app icon is Tomi as the app draws him, at the one size iOS asks for, and the shipped files are that
/// drawing pixel for pixel: when Tomi, a colour token or the framing changes, even by one level in one pixel, this
/// fails until the icon is rendered again (`scripts/render-app-icon.sh`). The icon is drawn by Core Graphics on
/// the CPU, which gives the same pixels on every run, so no tolerance is needed.
@MainActor struct AppIconRenderingTests {
    /// A plain stretch of tomato, left of the mouth and below the cheek, in grid units.
    private let tomato = AppIconFraming.pixel(of: CGPoint(x: 80, y: 200))
    private let corner = CGPoint(x: 4, y: 4)

    @Test(arguments: AppIconAppearance.allCases)
    func eachAppearanceRendersAsAnOpaqueSquareOf1024(_ appearance: AppIconAppearance) throws {
        let image = try #require(RenderedAppIcon.image(appearance))
        #expect(image.width == 1024)
        #expect(image.height == 1024)
        #expect([.none, .noneSkipLast, .noneSkipFirst].contains(image.alphaInfo))
    }

    @Test func tomiIsDrawnInTomatoRedOnACalmGround() throws {
        let pixels = IconPixels(try #require(RenderedAppIcon.image(.light)))
        let skin = pixels.rgb(at: tomato)
        #expect(skin[0] > 200)
        #expect(skin[1] < 120)
        #expect(ColorRole.wash.rgb(in: .light).isNear(pixels.rgb(at: corner)))
    }

    @Test func theDarkIconSitsOnTheNightWash() throws {
        let pixels = IconPixels(try #require(RenderedAppIcon.image(.dark)))
        #expect(ColorRole.wash.rgb(in: .dark).isNear(pixels.rgb(at: corner)))
    }

    @Test func theTintedIconIsGreySoIOSCanTintIt() throws {
        let pixels = IconPixels(try #require(RenderedAppIcon.image(.tinted)))
        for point in [tomato, corner] {
            let grey = pixels.rgb(at: point)
            #expect(grey[0] == grey[1])
            #expect(grey[1] == grey[2])
        }
    }

    @Test(arguments: AppIconAppearance.allCases)
    func theShippedIconIsTheCurrentDrawing(_ appearance: AppIconAppearance) throws {
        let rendered = IconPixels(try #require(RenderedAppIcon.image(appearance)))
        let shipped = try #require(IconPixels(contentsOf: appearance.shippedFile))
        #expect(shipped.width == 1024)
        #expect(shipped.height == 1024)
        let differing = rendered.differingPixels(from: shipped)
        #expect(differing == 0, "\(differing) pixels changed: run scripts/render-app-icon.sh and look at the icon")
    }
}
