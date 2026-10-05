import Foundation

/// Samples motion from elapsed animation time, never the wall clock.
nonisolated enum CompanionMotion {
    static func pose(state: CompanionState, elapsed: Float, moving: Bool) -> CompanionPose {
        var pose = state.pose
        guard moving else { return pose }
        breathe(&pose, at: elapsed)
        gesture(&pose, state: state, at: elapsed)
        return pose
    }

    private static func breathe(_ pose: inout CompanionPose, at time: Float) {
        pose.lift += 0.012 * sin(time * 1.7)
        pose.squash += 0.008 * sin(time * 1.7)
        pose.yaw += 0.025 * sin(time * 0.8)
        let blink = time.truncatingRemainder(dividingBy: 4.7)
        if blink > 4.45 {
            pose.eyes = max(0.08, abs(blink - 4.575) / 0.125)
        }
    }

    private static func gesture(_ pose: inout CompanionPose, state: CompanionState, at time: Float) {
        switch state {
        case .idle: pose.leftArm += 0.035 * sin(time * 1.7)
        case .listening: pose.tilt += 0.018 * sin(time * 2)
        case .thinking: pose.gaze.x += 0.009 * sin(time * 1.3)
        case .explaining: explain(&pose, at: time)
        case .celebrating: celebrate(&pose, at: time)
        }
    }

    private static func explain(_ pose: inout CompanionPose, at time: Float) {
        pose.mouth = 0.035 + 0.045 * abs(sin(time * 8))
        pose.rightArm += 0.16 * sin(time * 3)
        pose.tilt += 0.025 * sin(time * 2)
    }

    private static func celebrate(_ pose: inout CompanionPose, at time: Float) {
        pose.lift += 0.07 * abs(sin(time * 2.8))
        pose.squash += 0.025 * sin(time * 5.6)
        pose.leftArm += 0.09 * sin(time * 5.6)
        pose.rightArm -= 0.09 * sin(time * 5.6)
    }
}
