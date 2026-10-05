import Foundation

extension CompanionState {
    nonisolated var pose: CompanionPose {
        switch self {
        case .idle:
            CompanionPose(yaw: -0.06, tilt: -0.025)
        case .listening:
            CompanionPose(yaw: -0.10, tilt: -0.12, rightArm: 2.2, gaze: [0.01, 0.01], brow: 0.16)
        case .thinking:
            CompanionPose(yaw: 0.16, tilt: 0.09, rightArm: -1.15, gaze: [0.025, 0.026], brow: -0.22, mouth: 0.018)
        case .explaining:
            CompanionPose(yaw: -0.08, tilt: -0.03, rightArm: 1.45, brow: 0.10, mouth: 0.075)
        case .celebrating:
            CompanionPose(tilt: -0.04, leftArm: -2.35, rightArm: 2.35, brow: 0.22, mouth: 0.105)
        }
    }
}
