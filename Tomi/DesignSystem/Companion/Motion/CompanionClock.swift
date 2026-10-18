import Foundation

/// Turns the animation timeline's frame dates into seconds since the first frame drawn, and eases a change of
/// state from the pose last drawn. Not observed by SwiftUI: it only remembers between frames.
final class CompanionClock {
    private var firstFrame: Date?
    private var last: CompanionFrame?
    private var transition: CompanionTransition?

    func pose(state: CompanionState, at frame: Date, moving: Bool) -> CompanionPose {
        let elapsed = elapsed(at: frame)
        noteChange(to: state, moving: moving)
        var pose = CompanionMotion.pose(state: state, elapsed: elapsed, moving: moving)
        if let transition, moving, !transition.isFinished(at: elapsed) {
            pose = transition.pose(toward: pose, at: elapsed)
        }
        last = CompanionFrame(state: state, elapsed: elapsed, pose: pose)
        return pose
    }

    /// Without motion a new still pose shows at once; with motion it eases from where Tomi was.
    private func noteChange(to state: CompanionState, moving: Bool) {
        guard let last, last.state != state else { return }
        guard moving else {
            transition = nil
            return
        }
        transition = CompanionTransition(from: last.pose, startedAt: last.elapsed)
    }

    private func elapsed(at frame: Date) -> Double {
        guard let firstFrame else {
            firstFrame = frame
            return 0
        }
        return frame.timeIntervalSince(firstFrame)
    }
}
