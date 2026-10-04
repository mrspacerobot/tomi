import Foundation

/// A finished cook from the cook log, as the streak sees it. A cook stopped early is never one of these.
public struct CompletedCook: Hashable, Sendable {
    public let date: Date
    /// The cook's weekly goal when this was cooked, so a later change of goal never rejudges a past week.
    public let weeklyGoal: Int

    public init(date: Date, weeklyGoal: Int) {
        self.date = date
        self.weeklyGoal = weeklyGoal
    }
}
