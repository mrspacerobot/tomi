import SwiftUI

/// The tomato's crown peeking out from under the toque: pointed sepals lying on the head at both sides, and
/// on the right a short curved stem with one leaf, so he reads as a tomato even under his hat.
enum CompanionLeafPart {
    static func draw(in context: GraphicsContext, palette: CompanionPalette) {
        let pen = palette.line(CompanionInk.feature)
        context.fillAndInk(sepal, fill: palette.leaf, pen: pen)
        context.mirrored().fillAndInk(sepal, fill: palette.leaf, pen: pen)
        context.ink(stem, pen: palette.line(CompanionInk.stemOutline))
        context.ink(stem, pen: CompanionPen(color: palette.leaf, style: CompanionInk.stemFill))
        context.fillAndInk(leaf, fill: palette.leaf, pen: pen)
        context.ink(vein, pen: palette.line(CompanionInk.fine))
    }

    /// A pointed sepal from under the band, lying along the right of the head.
    private static var sepal: Path {
        var path = Path()
        path.move(to: CGPoint(x: 124, y: 86))
        path.addQuadCurve(to: CGPoint(x: 156, y: 101), control: CGPoint(x: 146, y: 84))
        path.addQuadCurve(to: CGPoint(x: 124, y: 93), control: CGPoint(x: 141, y: 101))
        path.closeSubpath()
        return path
    }

    private static var stem: Path {
        var path = Path()
        path.move(to: CGPoint(x: 133, y: 86))
        path.addQuadCurve(to: CGPoint(x: 143, y: 66), control: CGPoint(x: 133, y: 73))
        return path
    }

    /// A leaf off the top of the stem, pointing up and out.
    private static var leaf: Path {
        var path = Path()
        path.move(to: CGPoint(x: 142, y: 68))
        path.addQuadCurve(to: CGPoint(x: 170, y: 58), control: CGPoint(x: 152, y: 50))
        path.addQuadCurve(to: CGPoint(x: 142, y: 68), control: CGPoint(x: 162, y: 72))
        path.closeSubpath()
        return path
    }

    private static var vein: Path {
        var path = Path()
        path.move(to: CGPoint(x: 146, y: 66))
        path.addQuadCurve(to: CGPoint(x: 164, y: 59), control: CGPoint(x: 155, y: 60))
        return path
    }
}
