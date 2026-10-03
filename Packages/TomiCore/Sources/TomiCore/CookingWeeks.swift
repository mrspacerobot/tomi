import Foundation

/// Finished cooks grouped into the cook's calendar weeks: the days cooked in each week and the goal it had.
struct CookingWeeks {
    private struct Week {
        var days: Set<Date> = []
        var goal = GameRules.defaultWeeklyGoal
    }

    private var weeks: [Date: Week] = [:]

    init(cooks: [CompletedCook], calendar: Calendar) {
        for cook in cooks.sorted(by: { $0.date < $1.date }) {
            let start = calendar.startOfWeek(containing: cook.date)
            weeks[start, default: Week()].days.insert(calendar.startOfDay(for: cook.date))
            weeks[start]?.goal = GameRules.clampedWeeklyGoal(cook.weeklyGoal)
        }
    }

    func daysCooked(inWeekStarting start: Date) -> Int {
        weeks[start]?.days.count ?? 0
    }

    /// Judged by the goal of the week's latest cook, the goal the cook was working to at the time.
    func wasMet(weekStarting start: Date) -> Bool {
        guard let week = weeks[start] else { return false }
        return week.days.count >= week.goal
    }
}
