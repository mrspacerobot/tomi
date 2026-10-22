import Foundation

/// The last frame the clock drew, so a change of state can ease from it.
nonisolated struct CompanionFrame {
    let state: CompanionState
    let pose: CompanionPose
}
