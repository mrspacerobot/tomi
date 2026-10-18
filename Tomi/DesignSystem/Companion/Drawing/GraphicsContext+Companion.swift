import SwiftUI

extension GraphicsContext {
    /// Fills a shape, then inks its outline on top, like a cel: colour first, line last.
    func fillAndInk(_ path: Path, fill: Color, pen: CompanionPen) {
        self.fill(path, with: .color(fill))
        stroke(path, with: .color(pen.color), style: pen.style)
    }

    func ink(_ path: Path, pen: CompanionPen) {
        stroke(path, with: .color(pen.color), style: pen.style)
    }

    /// The same context reflected about Tomi's centre line, for the parts drawn once and used on both sides.
    func mirrored() -> GraphicsContext {
        var context = self
        context.translateBy(x: CompanionGrid.middle * 2, y: 0)
        context.scaleBy(x: -1, y: 1)
        return context
    }

    func rotated(around point: CGPoint, degrees: Double) -> GraphicsContext {
        var context = self
        context.translateBy(x: point.x, y: point.y)
        context.rotate(by: .degrees(degrees))
        context.translateBy(x: -point.x, y: -point.y)
        return context
    }

    /// Hops, squashes, stretches and leans the figure about the point between its feet.
    func posed(_ body: CompanionBodyPose) -> GraphicsContext {
        var context = self
        let ground = CompanionGrid.ground
        context.translateBy(x: ground.x, y: ground.y + body.lift)
        context.rotate(by: .degrees(body.tilt))
        context.scaleBy(x: body.stretchX, y: body.stretchY)
        context.translateBy(x: -ground.x, y: -ground.y)
        return context
    }
}
