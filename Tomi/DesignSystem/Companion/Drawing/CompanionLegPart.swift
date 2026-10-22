import SwiftUI

/// Short rubber-hose legs in cobalt shoes, toes turned out. Drawn for the right and mirrored for the left.
enum CompanionLegPart {
    static func draw(in context: GraphicsContext, palette: CompanionPalette) {
        drawLeg(in: context, palette: palette)
        drawLeg(in: context.mirrored(), palette: palette)
    }

    private static func drawLeg(in context: GraphicsContext, palette: CompanionPalette) {
        context.ink(leg, pen: palette.line(CompanionInk.limb))
        context.fillAndInk(shoe, fill: palette.shoe, pen: palette.line(CompanionInk.feature))
        context.ink(shine, pen: palette.shine(CompanionInk.detail))
    }

    private static var leg: Path {
        var path = Path()
        path.move(to: CGPoint(x: 115, y: 190))
        path.addQuadCurve(to: CGPoint(x: 122, y: 218), control: CGPoint(x: 118, y: 208))
        return path
    }

    private static var shoe: Path {
        Path(ellipseIn: CGRect(x: 115, y: 214, width: 29, height: 15))
    }

    private static var shine: Path {
        var path = Path()
        path.move(to: CGPoint(x: 126, y: 218.5))
        path.addQuadCurve(to: CGPoint(x: 136, y: 219), control: CGPoint(x: 131, y: 216.5))
        return path
    }
}
