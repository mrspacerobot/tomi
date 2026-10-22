import SwiftUI

/// A rubber-hose arm: one smooth ink line with no elbow, ending in a white glove.
enum CompanionArmPart {
    static func draw(_ arm: CompanionArmPose, in context: GraphicsContext, palette: CompanionPalette) {
        let swung = context.rotated(around: arm.shoulder, degrees: arm.swing)
        var hose = Path()
        hose.move(to: arm.shoulder)
        hose.addQuadCurve(to: arm.hand, control: arm.bend)
        swung.ink(hose, pen: CompanionPen(color: palette.line, style: CompanionInk.limb))
        CompanionGlovePart.draw(CompanionGlovePlacement(arm: arm), in: swung, palette: palette)
    }
}
