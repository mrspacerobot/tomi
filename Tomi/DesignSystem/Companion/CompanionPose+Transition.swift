import Foundation

extension CompanionPose {
    /// Exponential easing remains consistent at different render rates and during interrupted transitions.
    nonisolated mutating func approach(_ target: CompanionPose, fraction: Float) {
        yaw += (target.yaw - yaw) * fraction
        tilt += (target.tilt - tilt) * fraction
        lift += (target.lift - lift) * fraction
        squash += (target.squash - squash) * fraction
        leftArm += (target.leftArm - leftArm) * fraction
        rightArm += (target.rightArm - rightArm) * fraction
        expression(toward: target, fraction: fraction)
    }

    nonisolated private mutating func expression(toward target: CompanionPose, fraction: Float) {
        gaze += (target.gaze - gaze) * fraction
        brow += (target.brow - brow) * fraction
        mouth += (target.mouth - mouth) * fraction
        eyes = target.eyes
    }
}
