/// The way to the next rank, drawn from the XP and the rank bounds the server sent. It works out no rank and adds
/// no XP: it only lays the given numbers along the bar, and keeps an answer it cannot draw within the bar's ends.
public struct RankBar: Hashable, Sendable {
    /// XP since the rank started.
    public let earned: Int
    /// XP from the start of the rank to the next one.
    public let needed: Int
    /// XP still to go to the next rank.
    public let remaining: Int

    public init(xp: Int, rank: SnapshotRank) {
        needed = max(rank.nextAt - rank.startsAt, 0)
        earned = min(max(xp - rank.startsAt, 0), needed)
        remaining = needed - earned
    }

    /// From 0 to 1.
    public var fraction: Double {
        guard needed > 0 else {
            return 0
        }
        return Double(earned) / Double(needed)
    }
}
