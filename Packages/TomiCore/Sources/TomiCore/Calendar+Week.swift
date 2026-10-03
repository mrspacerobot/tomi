import Foundation

extension Calendar {
    /// The first moment of the week containing a date, by this calendar's first weekday and time zone.
    func startOfWeek(containing date: Date) -> Date {
        dateInterval(of: .weekOfYear, for: date)?.start ?? startOfDay(for: date)
    }

    func startOfWeek(before weekStart: Date) -> Date? {
        date(byAdding: .weekOfYear, value: -1, to: weekStart).map(startOfWeek(containing:))
    }

    /// Calendar days from the day of a date to the end of its week, that day included.
    func daysLeftInWeek(from date: Date) -> Int {
        guard let week = dateInterval(of: .weekOfYear, for: date) else { return 1 }
        return dateComponents([.day], from: startOfDay(for: date), to: week.end).day ?? 1
    }
}
