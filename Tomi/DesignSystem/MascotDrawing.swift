import SwiftUI

/// Paints Tomi's shapes in print order: each fill first, its outline on top.
struct MascotDrawing {
    private static let outline = StrokeStyle(lineWidth: 2.5, lineCap: .round, lineJoin: .round)
    private static let eyeOutlineWidth: CGFloat = 1.5

    let palette: MascotPalette

    /// Returns a context scaled and centred so the mascot's grid fills `size`.
    static func fitted(_ context: GraphicsContext, to size: CGSize) -> GraphicsContext {
        var context = context
        let scale = min(size.width, size.height) / MascotShapes.gridSize
        let drawn = MascotShapes.gridSize * scale
        context.translateBy(x: (size.width - drawn) / 2, y: (size.height - drawn) / 2)
        context.scaleBy(x: scale, y: scale)
        return context
    }

    func draw(in context: GraphicsContext) {
        paint(MascotShapes.leaf, fill: .yolk, in: context)
        paint(MascotShapes.body, fill: .printRed, in: context)
        drawFace(in: context)
        drawToque(in: context)
    }

    private func drawToque(in context: GraphicsContext) {
        for part in [MascotShapes.toqueCrown, MascotShapes.toqueBand] {
            context.fill(part, with: .color(palette.toque.color))
            context.stroke(part, with: .color(palette.toqueOutline.color), style: Self.outline)
        }
    }

    private func drawFace(in context: GraphicsContext) {
        for centerX in MascotShapes.eyeCenters {
            let eye = MascotShapes.eye(centerX: centerX)
            context.fill(eye, with: .color(palette.eye.color))
            context.stroke(eye, with: .color(palette.outline.color), lineWidth: Self.eyeOutlineWidth)
            context.fill(MascotShapes.pupil(centerX: centerX), with: .color(palette.face.color))
        }
        context.fill(MascotShapes.mouth, with: .color(palette.face.color))
    }

    private func paint(_ path: Path, fill: ColorRole, in context: GraphicsContext) {
        context.fill(path, with: .color(fill.color))
        context.stroke(path, with: .color(palette.outline.color), style: Self.outline)
    }
}
