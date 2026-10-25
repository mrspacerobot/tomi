import Foundation

/// The mouth's shape and size. For a grin, `width` is half the width from corner to corner and `open` runs from
/// a small closed smile (below 0) to a wide laugh (1). For a round mouth they are its half width and half height.
nonisolated struct CompanionMouth: CompanionBlendable {
    var shape: CompanionMouthShape = .grin
    var width: Double = 22
    var open: Double = 0

    static let smile = CompanionMouth()
    static let hmm = CompanionMouth(shape: .hmm, width: 10, open: 0)
    static let laugh = CompanionMouth(shape: .grin, width: 26, open: 1)

    /// Sizes mean different things for different shapes, so a change of shape cuts instead of blending.
    func blended(toward target: CompanionMouth, by fraction: Double) -> CompanionMouth {
        if shape != target.shape {
            return CompanionSnap.value(from: self, to: target, by: fraction)
        }
        return CompanionMouth(
            shape: shape,
            width: width.blended(toward: target.width, by: fraction),
            open: open.blended(toward: target.open, by: fraction)
        )
    }
}
