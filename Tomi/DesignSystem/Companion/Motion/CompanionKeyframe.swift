import Foundation

/// A value at a moment of a cycle, the moment given as a fraction of the cycle like a CSS keyframe.
nonisolated struct CompanionKeyframe<Value: CompanionBlendable>: Sendable {
    let at: Double
    let value: Value
}
