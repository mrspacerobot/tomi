/// The weekly streak as the server counted it in the cook's calendar.
public struct SnapshotStreak: Hashable, Decodable, Sendable {
    public let weeks: Int
    public let weeksBeforeThisWeek: Int
    public let daysThisWeek: Int
    public let goal: Int
    public let daysLeftInWeek: Int
    public let thisWeekMet: Bool
    public let atRisk: Bool
    public let lost: Bool
    public let weekStartsAt: ServerInstant
    /// Lets the app tell that a kept snapshot's week is over.
    public let weekEndsAt: ServerInstant
}
