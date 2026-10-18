import Foundation

/// Everything the face does. Brows are named from the cook's point of view.
nonisolated struct CompanionFacePose: CompanionBlendable {
    var eyes: CompanionEyes = .forward
    var leftBrow: CompanionBrow = .rest
    var rightBrow: CompanionBrow = .rest
    var mouth: CompanionMouth = .smile

    static let friendly = CompanionFacePose()

    func blended(toward target: CompanionFacePose, by fraction: Double) -> CompanionFacePose {
        CompanionFacePose(
            eyes: eyes.blended(toward: target.eyes, by: fraction),
            leftBrow: leftBrow.blended(toward: target.leftBrow, by: fraction),
            rightBrow: rightBrow.blended(toward: target.rightBrow, by: fraction),
            mouth: mouth.blended(toward: target.mouth, by: fraction)
        )
    }
}
