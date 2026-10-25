import SwiftUI

/// The mouth: a filled grin with a tongue, a round "oh", or a thoughtful line.
enum CompanionMouthPart {
    private static let middle: CGFloat = 100
    private static let corners: CGFloat = 152

    static func draw(_ mouth: CompanionMouth, in context: GraphicsContext, palette: CompanionPalette) {
        switch mouth.shape {
        case .grin: drawOpen(grin(mouth), in: context, palette: palette)
        case .round: drawOpen(round(mouth), in: context, palette: palette)
        case .hmm: context.ink(hmm(mouth), pen: CompanionPen(color: palette.feature, style: CompanionInk.brow))
        }
    }

    /// The corners rise and the lower lip drops as the grin opens; the upper lip keeps a small dip.
    private static func grin(_ mouth: CompanionMouth) -> Path {
        let width = CGFloat(mouth.width)
        let cornerY = corners - 4 * CGFloat(mouth.open)
        let lower = 26 + 18 * CGFloat(mouth.open)
        var path = Path()
        path.move(to: CGPoint(x: middle - width, y: cornerY))
        path.addQuadCurve(to: CGPoint(x: middle + width, y: cornerY), control: CGPoint(x: middle, y: cornerY + lower))
        path.addQuadCurve(to: CGPoint(x: middle - width, y: cornerY), control: CGPoint(x: middle, y: cornerY + 8))
        path.closeSubpath()
        return path
    }

    private static func round(_ mouth: CompanionMouth) -> Path {
        let width = CGFloat(mouth.width)
        let height = CGFloat(mouth.open)
        return Path(ellipseIn: CGRect(x: middle - width, y: 160 - height, width: width * 2, height: height * 2))
    }

    private static func hmm(_ mouth: CompanionMouth) -> Path {
        let width = CGFloat(mouth.width)
        var path = Path()
        path.move(to: CGPoint(x: middle + 2 - width, y: 161))
        path.addCurve(
            to: CGPoint(x: middle + 2 + width, y: 158),
            control1: CGPoint(x: middle + 2 - width / 3, y: 154),
            control2: CGPoint(x: middle + 2 + width / 3, y: 166)
        )
        return path
    }

    /// Fills the mouth, lays the tongue inside it, then inks the lips.
    private static func drawOpen(_ shape: Path, in context: GraphicsContext, palette: CompanionPalette) {
        context.fill(shape, with: .color(palette.feature))
        var inside = context
        inside.clip(to: shape)
        inside.fill(tongue(in: shape.boundingRect), with: .color(palette.blush))
        context.ink(shape, pen: palette.feature(CompanionInk.feature))
    }

    /// The tongue rests in the lower part of the open mouth; the mouth's outline clips it.
    private static func tongue(in box: CGRect) -> Path {
        let rect = CGRect(
            x: box.midX - box.width * 0.3,
            y: box.maxY - box.height * 0.42,
            width: box.width * 0.6,
            height: box.height * 0.6
        )
        return Path(ellipseIn: rect)
    }
}
