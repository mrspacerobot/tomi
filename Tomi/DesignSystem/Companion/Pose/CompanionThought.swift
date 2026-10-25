import Foundation

/// The three thought dots rising beside Tomi's head, from the smallest to the largest, as opacities.
nonisolated struct CompanionThought: CompanionBlendable {
    var first: Double = 0
    var second: Double = 0
    var third: Double = 0

    static let hidden = CompanionThought()
    /// Still: the dots grow stronger towards the largest, so the thought reads without motion.
    static let rising = CompanionThought(first: 0.35, second: 0.65, third: 1)

    func blended(toward target: CompanionThought, by fraction: Double) -> CompanionThought {
        CompanionThought(
            first: first.blended(toward: target.first, by: fraction),
            second: second.blended(toward: target.second, by: fraction),
            third: third.blended(toward: target.third, by: fraction)
        )
    }
}
