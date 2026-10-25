import Foundation

/// A part of a pose that can ease towards another value of its kind, for keyframes and for changes of state.
nonisolated protocol CompanionBlendable: Equatable, Sendable {
    /// `fraction` 0 gives this value, 1 gives `target`. Easings may overshoot past 1 for a springy snap.
    func blended(toward target: Self, by fraction: Double) -> Self
}
