import Foundation

/// A cubic Bézier timing curve, as in CSS, so the concept page's timings carry over exactly.
/// A second control point above 1 overshoots, which gives the snappy, springy landing of a cartoon.
nonisolated struct CompanionEasing: Equatable, Sendable {
    let x1: Double
    let y1: Double
    let x2: Double
    let y2: Double

    static let linear = CompanionEasing(x1: 0, y1: 0, x2: 1, y2: 1)
    static let ease = CompanionEasing(x1: 0.25, y1: 0.1, x2: 0.25, y2: 1)
    static let easeInOut = CompanionEasing(x1: 0.42, y1: 0, x2: 0.58, y2: 1)
    static let easeOut = CompanionEasing(x1: 0, y1: 0, x2: 0.58, y2: 1)
    /// The idle hop of the concept.
    static let bounce = CompanionEasing(x1: 0.3, y1: 1.6, x2: 0.5, y2: 1)
    /// The celebration pop of the concept.
    static let pop = CompanionEasing(x1: 0.3, y1: 1.5, x2: 0.5, y2: 1)

    /// The eased value for a progress from 0 to 1.
    func value(at progress: Double) -> Double {
        // The ends are exact, so a keyframe is reached exactly rather than within the search's precision.
        if progress <= 0 || progress >= 1 {
            return min(max(progress, 0), 1)
        }
        let parameter = parameter(forX: progress)
        return Self.curve(parameter, first: y1, second: y2)
    }

    /// Finds the curve parameter whose x is `target`. The x of the curve always rises, so halving converges.
    private func parameter(forX target: Double) -> Double {
        var range = 0.0...1.0
        for _ in 0..<30 {
            let middle = (range.lowerBound + range.upperBound) / 2
            if Self.curve(middle, first: x1, second: x2) < target {
                range = middle...range.upperBound
            } else {
                range = range.lowerBound...middle
            }
        }
        return (range.lowerBound + range.upperBound) / 2
    }

    private static func curve(_ parameter: Double, first: Double, second: Double) -> Double {
        let rest = 1 - parameter
        return 3 * rest * rest * parameter * first + 3 * rest * parameter * parameter * second
            + parameter * parameter * parameter
    }
}
