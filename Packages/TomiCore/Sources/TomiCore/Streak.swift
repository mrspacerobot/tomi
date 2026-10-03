/// The cook's weekly streak right now: how many weeks in a row they met their goal, and how this week is going.
/// Computed from the cook log on demand, never stored.
public struct Streak: Hashable, Sendable {
    /// Consecutive weeks with the goal met. The week in progress counts once it is met and never breaks it before.
    public let weeks: Int
    /// Days this week with at least one finished cook.
    public let daysThisWeek: Int
    /// This week's goal in cooking days.
    public let goal: Int
    /// Days left in this week, today included.
    public let daysLeftInWeek: Int

    public var isThisWeekMet: Bool {
        daysThisWeek >= goal
    }

    /// Still possible, but only by cooking on every day left.
    public var isAtRisk: Bool {
        !isThisWeekMet && daysStillNeeded == daysLeftInWeek
    }

    /// Too few days left to meet the goal. The streak ends when the week does.
    public var isLost: Bool {
        daysStillNeeded > daysLeftInWeek
    }

    private var daysStillNeeded: Int {
        max(goal - daysThisWeek, 0)
    }
}
