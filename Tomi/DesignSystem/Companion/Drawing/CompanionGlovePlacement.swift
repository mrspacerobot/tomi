import Foundation

/// Where a glove sits and which way it points: along the arm's last stretch, from the bend to the hand.
nonisolated struct CompanionGlovePlacement: Equatable {
    let center: CGPoint
    /// Radians; 0 points the fingers to the right of the screen.
    let angle: Double
    let thumb: Double
    let cupped: Bool

    init(arm: CompanionArmPose) {
        center = arm.hand
        angle = atan2(Double(arm.hand.y - arm.bend.y), Double(arm.hand.x - arm.bend.x))
        thumb = arm.thumb
        cupped = arm.cupped
    }
}
