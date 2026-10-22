import SwiftUI

/// The cream chef's toque, set at a jaunty tilt.
enum CompanionToquePart {
    /// Degrees; the toque leans to the cook's left.
    private static let tilt: Double = -5
    private static let pivot = CGPoint(x: 100, y: 82)
    /// Sits a touch higher than the sketch, leaving room for raised brows.
    private static let lift: CGFloat = -3

    static func draw(in context: GraphicsContext, palette: CompanionPalette) {
        var hat = context.rotated(around: pivot, degrees: tilt)
        hat.translateBy(x: 0, y: lift)
        let pen = CompanionPen(color: palette.line, style: CompanionInk.outline)
        hat.fillAndInk(crown, fill: palette.toque, pen: pen)
        hat.ink(creases, pen: CompanionPen(color: palette.line, style: CompanionInk.detail))
        hat.fillAndInk(band, fill: palette.toque, pen: pen)
    }

    private static var crown: Path {
        var path = Path()
        path.move(to: CGPoint(x: 66, y: 80))
        path.addQuadCurve(to: CGPoint(x: 72, y: 45), control: CGPoint(x: 50, y: 54))
        path.addQuadCurve(to: CGPoint(x: 100, y: 26), control: CGPoint(x: 78, y: 22))
        path.addQuadCurve(to: CGPoint(x: 128, y: 45), control: CGPoint(x: 122, y: 22))
        path.addQuadCurve(to: CGPoint(x: 134, y: 80), control: CGPoint(x: 150, y: 54))
        path.closeSubpath()
        return path
    }

    /// The pleats between the puffs.
    private static var creases: Path {
        var path = Path()
        path.move(to: CGPoint(x: 86, y: 50))
        path.addQuadCurve(to: CGPoint(x: 87, y: 70), control: CGPoint(x: 83, y: 60))
        path.move(to: CGPoint(x: 114, y: 50))
        path.addQuadCurve(to: CGPoint(x: 113, y: 70), control: CGPoint(x: 117, y: 60))
        return path
    }

    private static var band: Path {
        Path(roundedRect: CGRect(x: 65, y: 72, width: 70, height: 17), cornerRadius: 6)
    }
}
