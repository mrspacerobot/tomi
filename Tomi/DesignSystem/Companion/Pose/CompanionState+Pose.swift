import Foundation

extension CompanionState {
    /// The pose that says this state on its own, without motion.
    nonisolated var stillPose: CompanionPose {
        switch self {
        case .idle: .waving
        case .listening: .listening
        case .thinking: .thinking
        case .explaining: .explaining
        case .celebrating: .celebrating
        }
    }
}
