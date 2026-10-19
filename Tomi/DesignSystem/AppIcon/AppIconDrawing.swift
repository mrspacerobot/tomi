import SwiftUI

/// Paints Tomi so that the icon's crop of his grid (`AppIconFraming`) fills a square canvas.
struct AppIconDrawing {
    let figure: CompanionDrawing

    /// The whole grid is drawn at the icon's scale and shifted so the crop lands on the canvas; the rest of the
    /// grid falls outside it. The grid is sized rather than the context scaled, so the glow scales with Tomi.
    func draw(in context: GraphicsContext, size: CGSize) {
        let scale = AppIconFraming.scale(toSide: size.width)
        let crop = AppIconFraming.crop
        var framed = context
        framed.translateBy(x: -crop.minX * scale, y: -crop.minY * scale)
        let grid = CGSize(width: CompanionGrid.size.width * scale, height: CompanionGrid.size.height * scale)
        figure.draw(in: framed, size: grid)
    }
}
