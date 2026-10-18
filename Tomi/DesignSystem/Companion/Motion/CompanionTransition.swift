import Foundation

/// A quick ease from the pose Tomi held when the state changed into the new state's live pose. Short and
/// decelerating, so the change snaps like a cartoon without an arm teleporting across the body.
nonisolated struct CompanionTransition: Equatable {
    static let duration = 0.22

    let from: CompanionPose
    /// Elapsed render time when the state changed.
    let startedAt: Double

    func pose(toward target: CompanionPose, at elapsed: Double) -> CompanionPose {
        let progress = (elapsed - startedAt) / Self.duration
        if progress >= 1 {
            return target
        }
        return from.blended(toward: target, by: CompanionEasing.easeOut.value(at: progress))
    }

    func isFinished(at elapsed: Double) -> Bool {
        elapsed - startedAt >= Self.duration
    }
}
