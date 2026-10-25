import Foundation

extension Double: CompanionBlendable {
    nonisolated func blended(toward target: Double, by fraction: Double) -> Double {
        self + (target - self) * fraction
    }
}
