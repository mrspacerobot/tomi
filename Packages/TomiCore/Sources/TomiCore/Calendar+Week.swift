import Foundation

/// Week arithmetic for the streak, by this calendar's first weekday and time zone.
///
/// Foundation returns optionals here because some calendars have dates it cannot place. That does not happen
/// for the calendars an iPhone offers, so each fallback only keeps the streak sensible instead of crashing.
extension Calendar {
    /// The first moment of the week that contains `date`.
    func startOfWeek(containing date: Date) -> Date {
        guard let week = dateInterval(of: .weekOfYear, for: date) else {
            return startOfDay(for: date)
        }
        return week.start
    }

    /// The first moment of the week before the one that starts at `weekStart`.
    func startOfWeek(before weekStart: Date) -> Date? {
        guard let sameDayLastWeek = date(byAdding: .weekOfYear, value: -1, to: weekStart) else {
            return nil
        }
        return startOfWeek(containing: sameDayLastWeek)
    }

    /// How many days are left in the week of `date`, counting that day itself. Sunday of a Monday week gives 1.
    func daysLeftInWeek(from date: Date) -> Int {
        let onlyToday = 1
        guard let week = dateInterval(of: .weekOfYear, for: date) else {
            return onlyToday
        }
        let today = startOfDay(for: date)
        guard let daysLeft = dateComponents([.day], from: today, to: week.end).day else {
            return onlyToday
        }
        return daysLeft
    }
}
