import CoreGraphics

/// The still poses of the livelier states, drawn in `CompanionGrid` units like the concept sketch.
extension CompanionPose {
    /// Talking: both gloves open to the sides, brows lifted, mouth mid-word.
    nonisolated static let explaining = CompanionPose(
        body: CompanionBodyPose(tilt: -2),
        leftArm: CompanionArmPose(
            shoulder: CGPoint(x: 40, y: 144),
            bend: CGPoint(x: 22, y: 172),
            hand: CGPoint(x: 12, y: 146),
            thumb: 1
        ),
        rightArm: CompanionArmPose(
            shoulder: CGPoint(x: 160, y: 144),
            bend: CGPoint(x: 178, y: 172),
            hand: CGPoint(x: 188, y: 146),
            thumb: -1
        ),
        face: CompanionFacePose(
            eyes: CompanionEyes(look: CGPoint(x: 0, y: -1)),
            leftBrow: CompanionBrow(lift: -3, arch: 1.15),
            rightBrow: CompanionBrow(lift: -3, arch: 1.15),
            mouth: CompanionMouth(shape: .grin, width: 21, open: 0.5)
        )
    )

    /// Hooray: both arms thrown up, happy closed eyes, a wide open laugh and sparkles.
    nonisolated static let celebrating = CompanionPose(
        leftArm: CompanionArmPose(
            shoulder: CGPoint(x: 40, y: 136),
            bend: CGPoint(x: 17, y: 118),
            hand: CGPoint(x: 20, y: 82),
            thumb: -1
        ),
        rightArm: CompanionArmPose(
            shoulder: CGPoint(x: 160, y: 136),
            bend: CGPoint(x: 183, y: 118),
            hand: CGPoint(x: 180, y: 82)
        ),
        face: CompanionFacePose(
            eyes: CompanionEyes(happy: true),
            leftBrow: CompanionBrow(lift: -4, arch: 1.2),
            rightBrow: CompanionBrow(lift: -4, arch: 1.2),
            mouth: .laugh
        ),
        extras: CompanionExtras(sparkle: 1)
    )
}
