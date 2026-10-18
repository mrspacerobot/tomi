import SwiftUI

/// The periwinkle tomato leaf peeking out by the toque, with its vein.
enum CompanionLeafPart {
    static func draw(in context: GraphicsContext, palette: CompanionPalette) {
        context.fillAndInk(leaf, fill: palette.leaf, pen: palette.line(CompanionInk.feature))
        context.ink(vein, pen: palette.line(CompanionInk.fine))
    }

    private static var leaf: Path {
        var path = Path()
        path.move(to: CGPoint(x: 127, y: 87))
        path.addQuadCurve(to: CGPoint(x: 157, y: 90), control: CGPoint(x: 146, y: 74))
        path.addQuadCurve(to: CGPoint(x: 130, y: 94), control: CGPoint(x: 142, y: 99))
        path.closeSubpath()
        return path
    }

    private static var vein: Path {
        var path = Path()
        path.move(to: CGPoint(x: 133, y: 90))
        path.addQuadCurve(to: CGPoint(x: 151, y: 89), control: CGPoint(x: 142, y: 86))
        return path
    }
}
