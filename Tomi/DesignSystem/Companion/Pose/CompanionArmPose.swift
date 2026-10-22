import CoreGraphics

/// One rubber-hose arm: a curve from the shoulder through `bend` to the gloved hand, swung about the shoulder.
nonisolated struct CompanionArmPose: CompanionBlendable {
    var shoulder: CGPoint
    var bend: CGPoint
    var hand: CGPoint
    /// Degrees about the shoulder, for waves, taps and gestures.
    var swing: Double = 0
    /// Which side of the glove the thumb sits on, 1 or -1. With 1 it is on the left of the line from the bend
    /// to the hand, seen on screen, so a hanging left hand shows its thumb towards the body.
    var thumb: Double = 1
    /// A hand cupped by the face to listen, open towards the screen's right, instead of a resting mitt.
    var cupped = false

    static let restingLeft = CompanionArmPose(
        shoulder: CGPoint(x: 40, y: 142),
        bend: CGPoint(x: 22, y: 160),
        hand: CGPoint(x: 29, y: 181)
    )
    static let restingRight = CompanionArmPose(
        shoulder: CGPoint(x: 160, y: 142),
        bend: CGPoint(x: 178, y: 160),
        hand: CGPoint(x: 171, y: 181),
        thumb: -1
    )

    func swung(by degrees: Double) -> CompanionArmPose {
        var arm = self
        arm.swing += degrees
        return arm
    }

    func blended(toward target: CompanionArmPose, by fraction: Double) -> CompanionArmPose {
        CompanionArmPose(
            shoulder: shoulder.blended(toward: target.shoulder, by: fraction),
            bend: bend.blended(toward: target.bend, by: fraction),
            hand: hand.blended(toward: target.hand, by: fraction),
            swing: swing.blended(toward: target.swing, by: fraction),
            thumb: CompanionSnap.value(from: thumb, to: target.thumb, by: fraction),
            cupped: CompanionSnap.value(from: cupped, to: target.cupped, by: fraction)
        )
    }
}
