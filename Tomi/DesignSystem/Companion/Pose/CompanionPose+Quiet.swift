import CoreGraphics

/// The still poses of the quieter states, drawn in `CompanionGrid` units like the concept sketch.
extension CompanionPose {
    /// Hello: the right glove raised beside the toque, a friendly smile.
    nonisolated static let waving = CompanionPose(
        rightArm: CompanionArmPose(
            shoulder: CGPoint(x: 160, y: 138),
            bend: CGPoint(x: 183, y: 124),
            hand: CGPoint(x: 185, y: 94)
        )
    )

    /// Leaning in, a glove cupped by the side of the face, eyes wide and brows up.
    nonisolated static let listening = CompanionPose(
        body: CompanionBodyPose(tilt: -6),
        leftArm: CompanionArmPose(
            shoulder: CGPoint(x: 41, y: 140),
            bend: CGPoint(x: 12, y: 146),
            hand: CGPoint(x: 22, y: 124),
            cupped: true
        ),
        face: CompanionFacePose(
            eyes: CompanionEyes(look: CGPoint(x: -3, y: -2), openness: 1.08, pupil: 7.6),
            leftBrow: CompanionBrow(lift: -5, arch: 1.25),
            rightBrow: CompanionBrow(lift: -4, arch: 1.15),
            mouth: CompanionMouth(shape: .grin, width: 13, open: -0.45)
        )
    )

    /// Hmm: a glove tapping the chin, eyes glancing up, one brow raised, thought dots rising.
    nonisolated static let thinking = CompanionPose(
        body: CompanionBodyPose(tilt: 3),
        rightArm: CompanionArmPose(
            shoulder: CGPoint(x: 160, y: 142),
            bend: CGPoint(x: 176, y: 184),
            hand: CGPoint(x: 132, y: 177),
            thumb: -1
        ),
        face: CompanionFacePose(
            eyes: CompanionEyes(look: CGPoint(x: -5, y: -11)),
            leftBrow: CompanionBrow(lift: -5, arch: 1.3),
            rightBrow: CompanionBrow(lift: 2, arch: 0.25),
            mouth: .hmm
        ),
        extras: CompanionExtras(thought: .rising)
    )
}
