import Foundation

/// A value that cannot be blended, such as a mouth shape, switches halfway through a change, like a cartoon cut.
nonisolated enum CompanionSnap {
    static func value<Value>(from start: Value, to end: Value, by fraction: Double) -> Value {
        if fraction < 0.5 {
            return start
        }
        return end
    }
}
