import SwiftUI

/// Paints one pose of Tomi from the shared parts, back to front, with a soft warm glow around the figure.
struct CompanionDrawing {
    let pose: CompanionPose
    let palette: CompanionPalette

    func draw(in context: GraphicsContext, size: CGSize) {
        let fit = CompanionGrid.fit(in: size)
        var figure = context
        figure.translateBy(x: fit.origin.x, y: fit.origin.y)
        figure.scaleBy(x: fit.scale, y: fit.scale)
        figure.translateBy(x: CompanionGrid.figureOrigin.x, y: CompanionGrid.figureOrigin.y)
        CompanionExtrasPart.draw(pose.extras, in: figure, palette: palette)
        var glowing = figure
        let glow = palette.glow.opacity(CompanionInk.glowOpacity)
        glowing.addFilter(.shadow(color: glow, radius: CompanionInk.glowRadius * fit.scale))
        glowing.drawLayer { layer in drawCharacter(in: layer) }
    }

    /// The left arm sits behind the body and the right in front, so gestures across the face read clearly.
    private func drawCharacter(in context: GraphicsContext) {
        let body = context.posed(pose.body)
        CompanionLegPart.draw(in: body, palette: palette)
        CompanionArmPart.draw(pose.leftArm, in: body, palette: palette)
        CompanionBodyPart.draw(in: body, palette: palette)
        CompanionToquePart.draw(in: body, palette: palette)
        CompanionFacePart.draw(pose.face, in: body, palette: palette)
        CompanionArmPart.draw(pose.rightArm, in: body, palette: palette)
    }
}
