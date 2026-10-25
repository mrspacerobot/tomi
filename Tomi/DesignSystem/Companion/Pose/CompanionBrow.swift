import Foundation

/// One eyebrow: raised or lowered, and how strongly it arches.
nonisolated struct CompanionBrow: CompanionBlendable {
    /// Up is negative, in grid units.
    var lift: Double = 0
    /// 1 is the resting arch, 0 is flat.
    var arch: Double = 1

    static let rest = CompanionBrow()

    func blended(toward target: CompanionBrow, by fraction: Double) -> CompanionBrow {
        CompanionBrow(
            lift: lift.blended(toward: target.lift, by: fraction),
            arch: arch.blended(toward: target.arch, by: fraction)
        )
    }
}
