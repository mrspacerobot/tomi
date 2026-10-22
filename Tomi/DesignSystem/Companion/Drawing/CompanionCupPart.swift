import SwiftUI

/// A glove cupped by the face to listen: curled fingers forming an open "C" towards the face, with the thumb
/// tucked under and the cuff turned along the arm.
enum CompanionCupPart {
    /// How far past the wrist the cupped hand sits, along the arm.
    private static let reach: CGFloat = 15

    static func draw(_ glove: CompanionGlovePlacement, in context: GraphicsContext, palette: CompanionPalette) {
        let pen = palette.line(CompanionInk.feature)
        var wrist = context
        wrist.translateBy(x: glove.center.x, y: glove.center.y)
        wrist.rotate(by: .radians(glove.angle))
        wrist.fillAndInk(cuff, fill: palette.white, pen: pen)
        var hand = context
        hand.translateBy(x: glove.center.x + reach * cos(glove.angle), y: glove.center.y + reach * sin(glove.angle))
        hand.fillAndInk(thumb, fill: palette.white, pen: pen)
        hand.fillAndInk(cup, fill: palette.white, pen: pen)
        hand.ink(fingers, pen: palette.line(CompanionInk.fine))
    }

    private static var cuff: Path {
        Path(roundedRect: CGRect(x: -5, y: -9, width: 10, height: 18), cornerRadius: 4.5)
    }

    private static var thumb: Path {
        Path(ellipseIn: CGRect(x: -6, y: 9, width: 15, height: 10))
    }

    /// The back of the hand bulges away from the face; the fingertips curl towards it at top and bottom.
    private static var cup: Path {
        var path = Path()
        path.move(to: CGPoint(x: 4, y: -18))
        path.addCurve(to: CGPoint(x: 4, y: 17), control1: CGPoint(x: -22, y: -18), control2: CGPoint(x: -22, y: 17))
        path.addQuadCurve(to: CGPoint(x: 9, y: 9), control: CGPoint(x: 12, y: 16))
        path.addCurve(to: CGPoint(x: 9, y: -10), control1: CGPoint(x: 1, y: 7), control2: CGPoint(x: 1, y: -8))
        path.addQuadCurve(to: CGPoint(x: 4, y: -18), control: CGPoint(x: 13, y: -18))
        path.closeSubpath()
        return path
    }

    /// Creases between the curled fingers.
    private static var fingers: Path {
        var path = Path()
        path.move(to: CGPoint(x: -14, y: -7))
        path.addQuadCurve(to: CGPoint(x: -5, y: -8), control: CGPoint(x: -9, y: -10))
        path.move(to: CGPoint(x: -15, y: 1))
        path.addQuadCurve(to: CGPoint(x: -6, y: 0), control: CGPoint(x: -10, y: -2))
        return path
    }
}
