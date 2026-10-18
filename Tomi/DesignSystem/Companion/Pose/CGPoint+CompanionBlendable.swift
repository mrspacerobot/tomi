import CoreGraphics

extension CGPoint: CompanionBlendable {
    nonisolated func blended(toward target: CGPoint, by fraction: Double) -> CGPoint {
        CGPoint(
            x: Double(x).blended(toward: Double(target.x), by: fraction),
            y: Double(y).blended(toward: Double(target.y), by: fraction)
        )
    }
}
