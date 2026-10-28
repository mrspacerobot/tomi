import Foundation

/// Days of October and November 2026 for the saved data tests, built from numbers and never from the clock.
extension Date {
    /// Six in the evening on that day, in Greenwich time.
    static func october(_ day: Int) -> Date {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = .gmt
        return calendar.date(from: DateComponents(year: 2026, month: 10, day: day, hour: 18))!
    }

    /// Six in the evening on that day of November, in Greenwich time.
    static func november(_ day: Int) -> Date {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = .gmt
        return calendar.date(from: DateComponents(year: 2026, month: 11, day: day, hour: 18))!
    }
}
