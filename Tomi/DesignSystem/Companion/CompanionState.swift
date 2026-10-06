import Foundation

/// Presentation inputs supplied by a caller, independent of AI or microphone availability.
nonisolated enum CompanionState: String, CaseIterable {
    case idle, listening, thinking, explaining, celebrating
}
