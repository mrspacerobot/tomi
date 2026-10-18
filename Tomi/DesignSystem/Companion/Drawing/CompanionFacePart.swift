import SwiftUI

/// The face that fills the body: eyes, brows, mouth.
enum CompanionFacePart {
    /// The face sits a little lower than in the sketch, so a raised brow clears the toque's band.
    private static let drop: CGFloat = 4

    static func draw(_ face: CompanionFacePose, in context: GraphicsContext, palette: CompanionPalette) {
        var lowered = context
        lowered.translateBy(x: 0, y: drop)
        CompanionMouthPart.draw(face.mouth, in: lowered, palette: palette)
        CompanionEyesPart.draw(face.eyes, in: lowered, palette: palette)
        CompanionBrowsPart.draw(face, in: lowered, palette: palette)
    }
}
