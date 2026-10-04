import Foundation

/// One calendar week of the cook log: the days with a finished cook, and the goal the cook had that week.
struct CookingWeek {
    private(set) var daysCooked: Set<Date> = []
    /// The weekly goal recorded with the latest cook of the week.
    private(set) var goal = GameRules.defaultWeeklyGoal
    private var latestCookDate = Date.distantPast

    var isGoalMet: Bool {
        daysCooked.count >= goal
    }

    /// Adds a finished cook. `day` is the start of the calendar day it was cooked on.
    mutating func add(_ cook: CompletedCook, day: Date) {
        daysCooked.insert(day)
        if cook.date >= latestCookDate {
            latestCookDate = cook.date
            goal = GameRules.clampedWeeklyGoal(cook.weeklyGoal)
        }
    }
}
