import Foundation

/// When a cook took place, how it ended, and the weekly goal the cook had set at the time.
public struct CookSession: Hashable, Sendable {
    public let date: Date
    public let result: CookResult
    /// The cook's weekly goal when this was cooked, so a later change of goal never rejudges a past week.
    public let weeklyGoal: Int

    public init(date: Date, result: CookResult, weeklyGoal: Int) {
        self.date = date
        self.result = result
        self.weeklyGoal = weeklyGoal
    }
}
