import Foundation

/// A complete drawing of Tomi at one moment, in the units of `CompanionGrid`. A still pose carries the whole
/// meaning of its state, so Reduce Motion and the printed mascot lose nothing.
nonisolated struct CompanionPose: CompanionBlendable {
    var body: CompanionBodyPose = .rest
    var leftArm: CompanionArmPose = .restingLeft
    var rightArm: CompanionArmPose = .restingRight
    var face: CompanionFacePose = .friendly
    var extras: CompanionExtras = .none

    func blended(toward target: CompanionPose, by fraction: Double) -> CompanionPose {
        CompanionPose(
            body: body.blended(toward: target.body, by: fraction),
            leftArm: leftArm.blended(toward: target.leftArm, by: fraction),
            rightArm: rightArm.blended(toward: target.rightArm, by: fraction),
            face: face.blended(toward: target.face, by: fraction),
            extras: extras.blended(toward: target.extras, by: fraction)
        )
    }
}
