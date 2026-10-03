import Foundation

@testable import TomiCore

/// A fixed calendar and dates for streak tests, so they never depend on the machine's clock, zone or locale.
struct StreakTestCalendar {
    let calendar: Calendar

    init(timeZone: String = "UTC", firstWeekday: Int = 2) {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: timeZone)!
        calendar.firstWeekday = firstWeekday
        self.calendar = calendar
    }

    /// A moment on a day written as "2026-10-05", at 6 pm unless another hour is given.
    func date(_ day: String, hour: Int = 18) -> Date {
        let parts = day.split(separator: "-").map { Int($0)! }
        return calendar.date(from: DateComponents(year: parts[0], month: parts[1], day: parts[2], hour: hour))!
    }

    func cooks(_ days: [String], goal: Int = 2) -> [CompletedCook] {
        days.map { CompletedCook(date: date($0), weeklyGoal: goal) }
    }

    func streak(_ cooks: [CompletedCook], goal: Int = 2, on day: String) -> Streak {
        StreakRules(calendar: calendar).streak(for: cooks, goal: goal, now: date(day))
    }
}
