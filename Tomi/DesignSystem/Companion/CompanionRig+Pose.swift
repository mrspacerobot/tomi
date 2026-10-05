import RealityKit

extension CompanionRig {
    func apply(_ pose: CompanionPose) {
        body.position.y = pose.lift
        body.scale = [1 / pose.squash, pose.squash, 1]
        body.orientation = orientation(for: pose)
        CompanionSculpt.turn(leftArm, by: pose.leftArm)
        CompanionSculpt.turn(rightArm, by: pose.rightArm)
        rightArm.position.z = pose.rightArmDepth
        face.apply(pose)
    }

    private func orientation(for pose: CompanionPose) -> simd_quatf {
        var yaw = pose.yaw
        if presentation.turned { yaw += 0.70 }
        return simd_quatf(angle: yaw, axis: [0, 1, 0]) * simd_quatf(angle: pose.tilt, axis: [0, 0, 1])
    }
}
