import Foundation

/// Days of autumn 2026 for the streak tests, as typed values instead of date strings.
/// Mondays: 14, 21 and 28 September, 5, 19 and 26 October, 2 November.
extension DateComponents {
    static func september(_ day: Int) -> DateComponents {
        DateComponents(year: 2026, month: 9, day: day)
    }

    static func october(_ day: Int) -> DateComponents {
        DateComponents(year: 2026, month: 10, day: day)
    }

    static func november(_ day: Int) -> DateComponents {
        DateComponents(year: 2026, month: 11, day: day)
    }
}
