import SwiftUI

/// Paints Tomi's shapes in print order: fills first, cobalt outline on top.
enum MascotDrawing {
    private static let outline = StrokeStyle(lineWidth: 2.5, lineCap: .round, lineJoin: .round)

    /// Returns a context scaled and centred so the mascot's grid fills `size`.
    static func fitted(_ context: GraphicsContext, to size: CGSize) -> GraphicsContext {
        var context = context
        let scale = min(size.width, size.height) / MascotShapes.gridSize
        let drawn = MascotShapes.gridSize * scale
        context.translateBy(x: (size.width - drawn) / 2, y: (size.height - drawn) / 2)
        context.scaleBy(x: scale, y: scale)
        return context
    }

    static func draw(in context: GraphicsContext) {
        context.fill(MascotShapes.shadow, with: .color(Theme.ink.opacity(0.12)))
        outlined(MascotShapes.leaf, fill: Theme.yolk, in: context)
        outlined(MascotShapes.body, fill: Theme.printRed, in: context)
        drawFace(in: context)
        outlined(MascotShapes.toqueCrown, fill: Theme.paper, in: context)
        outlined(MascotShapes.toqueBand, fill: Theme.paper, in: context)
    }

    private static func drawFace(in context: GraphicsContext) {
        for centerX in MascotShapes.eyeCenters {
            let eye = MascotShapes.eye(centerX: centerX)
            context.fill(eye, with: .color(Theme.paper))
            context.stroke(eye, with: .color(Theme.cobalt), lineWidth: 1.5)
            context.fill(MascotShapes.pupil(centerX: centerX), with: .color(Theme.ink))
        }
        context.fill(MascotShapes.mouth, with: .color(Theme.ink))
    }

    private static func outlined(_ path: Path, fill: Color, in context: GraphicsContext) {
        context.fill(path, with: .color(fill))
        context.stroke(path, with: .color(Theme.cobalt), style: outline)
    }
}
