import Foundation

/// Samples Tomi's pose from elapsed render time, never the wall clock. Without movement it gives the still pose.
nonisolated enum CompanionMotion {
    static func pose(state: CompanionState, elapsed: Double, moving: Bool) -> CompanionPose {
        guard moving else { return state.stillPose }
        switch state {
        case .idle: return idle(at: elapsed)
        case .listening: return listening(at: elapsed)
        case .thinking: return thinking(at: elapsed)
        case .explaining: return explaining(at: elapsed)
        case .celebrating: return celebrating(at: elapsed)
        }
    }

    private static func idle(at elapsed: Double) -> CompanionPose {
        var pose = CompanionPose.waving
        pose.body = CompanionBodyTracks.hop.value(at: elapsed)
        pose.rightArm = pose.rightArm.swung(by: CompanionSwingTracks.wave.value(at: elapsed))
        pose.face.eyes.openness = CompanionFaceTracks.blink.value(at: elapsed)
        return pose
    }

    private static func listening(at elapsed: Double) -> CompanionPose {
        var pose = CompanionPose.listening
        pose.body = CompanionBodyTracks.lean.value(at: elapsed)
        pose.leftArm = pose.leftArm.swung(by: CompanionSwingTracks.cup.value(at: elapsed))
        let blink = CompanionFaceTracks.slowBlink.value(at: elapsed)
        pose.face.eyes.openness = CompanionPose.listening.face.eyes.openness * blink
        return pose
    }

    private static func thinking(at elapsed: Double) -> CompanionPose {
        var pose = CompanionPose.thinking
        pose.rightArm = pose.rightArm.swung(by: CompanionSwingTracks.tap.value(at: elapsed))
        pose.face.eyes.look = CompanionFaceTracks.glance.value(at: elapsed)
        pose.face.eyes.openness = CompanionFaceTracks.slowBlink.value(at: elapsed)
        pose.extras.thought = thought(at: elapsed)
        return pose
    }

    private static func thought(at elapsed: Double) -> CompanionThought {
        CompanionThought(
            first: CompanionFaceTracks.dot.value(at: elapsed),
            second: CompanionFaceTracks.dot.value(at: elapsed, delay: 0.2),
            third: CompanionFaceTracks.dot.value(at: elapsed, delay: 0.4)
        )
    }

    private static func explaining(at elapsed: Double) -> CompanionPose {
        var pose = CompanionPose.explaining
        pose.body = CompanionBodyTracks.bob.value(at: elapsed)
        pose.leftArm = pose.leftArm.swung(by: CompanionSwingTracks.gesture.value(at: elapsed))
        pose.rightArm = pose.rightArm.swung(by: -CompanionSwingTracks.gesture.value(at: elapsed, delay: 0.8))
        pose.face = speaking(pose.face, at: elapsed)
        return pose
    }

    private static func speaking(_ face: CompanionFacePose, at elapsed: Double) -> CompanionFacePose {
        var face = face
        let accent = CompanionFaceTracks.accent.value(at: elapsed)
        face.leftBrow.lift = accent
        face.rightBrow.lift = accent
        face.mouth = CompanionSpeech.mouth(at: elapsed)
        face.eyes.openness = CompanionFaceTracks.blink.value(at: elapsed)
        return face
    }

    private static func celebrating(at elapsed: Double) -> CompanionPose {
        var pose = CompanionPose.celebrating
        let cheer = CompanionSwingTracks.cheer.value(at: elapsed)
        pose.body = CompanionBodyTracks.pop.value(at: elapsed)
        pose.leftArm = pose.leftArm.swung(by: -cheer)
        pose.rightArm = pose.rightArm.swung(by: cheer)
        pose.extras.sparkle = CompanionFaceTracks.twinkle.value(at: elapsed)
        return pose
    }
}
