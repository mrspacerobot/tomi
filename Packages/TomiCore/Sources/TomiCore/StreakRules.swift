import Foundation

/// Counts the weekly streak: consecutive weeks in which the cook cooked on at least their goal's number of days.
/// Weekly, not daily, because few people cook a full lesson every day.
public struct StreakRules: Sendable {
    /// The cook's own calendar (`Calendar.current` in the app), which sets the first weekday and the time zone.
    public let calendar: Calendar

    public init(calendar: Calendar) {
        self.calendar = calendar
    }

    /// The streak at `now`, from the finished cooks and the cook's current weekly goal.
    public func streak(for cooks: [CompletedCook], goal: Int, now: Date) -> Streak {
        let weeks = CookingWeeks(cooks: cooks, calendar: calendar)
        let thisWeek = calendar.startOfWeek(containing: now)
        let goal = GameRules.clampedWeeklyGoal(goal)
        let daysThisWeek = weeks.daysCooked(inWeekStarting: thisWeek)
        return Streak(
            weeks: metWeeksInARow(before: thisWeek, in: weeks) + (daysThisWeek >= goal ? 1 : 0),
            daysThisWeek: daysThisWeek,
            goal: goal,
            daysLeftInWeek: calendar.daysLeftInWeek(from: now)
        )
    }

    private func metWeeksInARow(before thisWeek: Date, in weeks: CookingWeeks) -> Int {
        var count = 0
        var week = calendar.startOfWeek(before: thisWeek)
        while let start = week, weeks.wasMet(weekStarting: start) {
            count += 1
            week = calendar.startOfWeek(before: start)
        }
        return count
    }
}
