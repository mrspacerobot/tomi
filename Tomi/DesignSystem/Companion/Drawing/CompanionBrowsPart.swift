import SwiftUI

/// Two thick arched brows. The right is the left one mirrored, with its own pose.
enum CompanionBrowsPart {
    private static let start = CGPoint(x: 70, y: 100)
    private static let end = CGPoint(x: 96, y: 99)
    private static let peak = CGPoint(x: 84, y: 92)

    static func draw(_ face: CompanionFacePose, in context: GraphicsContext, palette: CompanionPalette) {
        let pen = CompanionPen(color: palette.feature, style: CompanionInk.brow)
        context.ink(brow(face.leftBrow), pen: pen)
        context.mirrored().ink(brow(face.rightBrow), pen: pen)
    }

    private static func brow(_ pose: CompanionBrow) -> Path {
        let lift = CGFloat(pose.lift)
        let base = (start.y + end.y) / 2
        let control = CGPoint(x: peak.x, y: base + (peak.y - base) * CGFloat(pose.arch) + lift)
        var path = Path()
        path.move(to: CGPoint(x: start.x, y: start.y + lift))
        path.addQuadCurve(to: CGPoint(x: end.x, y: end.y + lift), control: control)
        return path
    }
}
