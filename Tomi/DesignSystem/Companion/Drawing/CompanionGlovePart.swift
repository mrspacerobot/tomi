import SwiftUI

/// A puffy white cartoon glove with a rolled cuff and a thumb, drawn pointing along its own x axis.
enum CompanionGlovePart {
    static func draw(_ glove: CompanionGlovePlacement, in context: GraphicsContext, palette: CompanionPalette) {
        var hand = context
        hand.translateBy(x: glove.center.x, y: glove.center.y)
        hand.rotate(by: .radians(glove.angle))
        hand.scaleBy(x: 1, y: glove.thumb)
        let pen = CompanionPen(color: palette.line, style: CompanionInk.feature)
        hand.fillAndInk(cuff, fill: palette.white, pen: pen)
        hand.fillAndInk(thumb, fill: palette.white, pen: pen)
        hand.fillAndInk(mitt, fill: palette.white, pen: pen)
        hand.ink(seam, pen: CompanionPen(color: palette.line, style: CompanionInk.fine))
    }

    private static var cuff: Path {
        Path(roundedRect: CGRect(x: -18, y: -10, width: 10, height: 20), cornerRadius: 4.5)
    }

    private static var thumb: Path {
        Path(ellipseIn: CGRect(x: -6, y: -18.5, width: 11, height: 15))
    }

    private static var mitt: Path {
        Path(ellipseIn: CGRect(x: -11, y: -12, width: 27, height: 24))
    }

    /// The roll of the cuff.
    private static var seam: Path {
        var path = Path()
        path.move(to: CGPoint(x: -13, y: -7))
        path.addLine(to: CGPoint(x: -13, y: 7))
        return path
    }
}
