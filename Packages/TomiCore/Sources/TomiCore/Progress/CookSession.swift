import Foundation

/// When a cook took place, how it ended, and the weekly goal the cook had set at the time.
public struct CookSession: Hashable, Sendable {
    public let date: Date
    public let result: CookResult
    /// The cook's weekly goal when this was cooked, so a later change of goal never rejudges a past week.
    public let weeklyGoal: Int
    /// The zone the cook was made in, recorded when the cook is saved, so the server counts it on the day it was
    /// cooked there however far the cook travels before it is sent. Missing for cooks saved before it was recorded.
    public var timeZone: TimeZone?

    public init(date: Date, result: CookResult, weeklyGoal: Int) {
        self.date = date
        self.result = result
        self.weeklyGoal = weeklyGoal
    }
}
