import Foundation

/// Turns the animation timeline's frame dates into seconds of motion (`CompanionElapsed`), and eases a change
/// of state from the pose last drawn, starting on the frame that sees the change. Not observed by SwiftUI:
/// it only remembers between frames.
final class CompanionClock {
    private var elapsed = CompanionElapsed()
    private var last: CompanionFrame?
    private var transition: CompanionTransition?

    func pose(state: CompanionState, at frame: Date, moving: Bool) -> CompanionPose {
        let now = elapsed.advance(to: frame, moving: moving)
        noteChange(to: state, moving: moving, at: now)
        var pose = CompanionMotion.pose(state: state, elapsed: now, moving: moving)
        if let transition, moving, !transition.isFinished(at: now) {
            pose = transition.pose(toward: pose, at: now)
        }
        last = CompanionFrame(state: state, pose: pose)
        return pose
    }

    /// Without motion a new still pose shows at once; with motion it eases from where Tomi was.
    private func noteChange(to state: CompanionState, moving: Bool, at now: Double) {
        guard let last, last.state != state else { return }
        guard moving else {
            transition = nil
            return
        }
        transition = CompanionTransition(from: last.pose, startedAt: now)
    }
}
