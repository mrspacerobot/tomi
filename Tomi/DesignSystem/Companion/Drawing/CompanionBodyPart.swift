import SwiftUI

/// The tomato: a flat red body with a cel-shaded lower edge, a shine, rosy cheeks and a thick outline.
enum CompanionBodyPart {
    static let outline = Path(ellipseIn: CGRect(x: 38, y: 84, width: 124, height: 112))

    static func draw(in context: GraphicsContext, palette: CompanionPalette) {
        context.fill(outline, with: .color(palette.tomato))
        drawShade(in: context, palette: palette)
        drawShine(in: context, palette: palette)
        drawCheeks(in: context, palette: palette)
        context.ink(outline, pen: CompanionPen(color: palette.line, style: CompanionInk.outline))
    }

    /// The body minus itself moved up and left leaves a crescent along the lower right.
    private static func drawShade(in context: GraphicsContext, palette: CompanionPalette) {
        let lit = Path(ellipseIn: CGRect(x: 31, y: 75, width: 126, height: 113))
        context.fill(outline.subtracting(lit), with: .color(palette.shade))
    }

    private static func drawShine(in context: GraphicsContext, palette: CompanionPalette) {
        var shine = Path()
        shine.move(to: CGPoint(x: 57, y: 120))
        shine.addQuadCurve(to: CGPoint(x: 84, y: 93), control: CGPoint(x: 63, y: 99))
        let pen = CompanionPen(color: palette.white.opacity(CompanionInk.shineOpacity), style: CompanionInk.brow)
        context.ink(shine, pen: pen)
        let dot = Path(ellipseIn: CGRect(x: 51.5, y: 128, width: 5, height: 5))
        context.fill(dot, with: .color(palette.white.opacity(CompanionInk.shineOpacity)))
    }

    private static func drawCheeks(in context: GraphicsContext, palette: CompanionPalette) {
        let blush = GraphicsContext.Shading.color(palette.blush.opacity(CompanionInk.blushOpacity))
        context.fill(Path(ellipseIn: CGRect(x: 52, y: 149, width: 16, height: 10)), with: blush)
        context.fill(Path(ellipseIn: CGRect(x: 132, y: 149, width: 16, height: 10)), with: blush)
    }
}
