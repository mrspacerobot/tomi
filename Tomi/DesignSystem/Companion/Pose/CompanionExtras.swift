import Foundation

/// Marks drawn around Tomi rather than on him: thought dots and celebration sparkles.
nonisolated struct CompanionExtras: CompanionBlendable {
    var thought: CompanionThought = .hidden
    /// The sparkles' scale; 0 hides them.
    var sparkle: Double = 0

    static let none = CompanionExtras()

    func blended(toward target: CompanionExtras, by fraction: Double) -> CompanionExtras {
        CompanionExtras(
            thought: thought.blended(toward: target.thought, by: fraction),
            sparkle: sparkle.blended(toward: target.sparkle, by: fraction)
        )
    }
}
