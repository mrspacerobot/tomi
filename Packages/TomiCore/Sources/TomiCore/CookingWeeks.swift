import Foundation

/// Finished cooks grouped into the cook's calendar weeks. Each week is found by the date it starts on.
struct CookingWeeks {
    private var weeksByStart: [Date: CookingWeek] = [:]

    init(cooks: [CompletedCook], calendar: Calendar) {
        for cook in cooks {
            let weekStart = calendar.startOfWeek(containing: cook.date)
            let day = calendar.startOfDay(for: cook.date)
            var week = weeksByStart[weekStart, default: CookingWeek()]
            week.add(cook, day: day)
            weeksByStart[weekStart] = week
        }
    }

    func daysCooked(inWeekStarting weekStart: Date) -> Int {
        guard let week = weeksByStart[weekStart] else {
            return 0
        }
        return week.daysCooked.count
    }

    /// A week with no cooks never meets its goal.
    func wasGoalMet(inWeekStarting weekStart: Date) -> Bool {
        guard let week = weeksByStart[weekStart] else {
            return false
        }
        return week.isGoalMet
    }
}
