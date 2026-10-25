import CoreGraphics

/// Both eyes: where the pupils look, how open the lids are, and the closed happy arcs of a celebration.
nonisolated struct CompanionEyes: CompanionBlendable {
    /// Pupil offset from looking straight at the cook, in grid units; up is negative.
    var look: CGPoint = .zero
    /// 1 is open, near 0 is a blink, above 1 is wide and attentive.
    var openness: Double = 1
    var pupil: Double = 7
    var happy = false

    static let forward = CompanionEyes()

    func blended(toward target: CompanionEyes, by fraction: Double) -> CompanionEyes {
        CompanionEyes(
            look: look.blended(toward: target.look, by: fraction),
            openness: openness.blended(toward: target.openness, by: fraction),
            pupil: pupil.blended(toward: target.pupil, by: fraction),
            happy: CompanionSnap.value(from: happy, to: target.happy, by: fraction)
        )
    }
}
