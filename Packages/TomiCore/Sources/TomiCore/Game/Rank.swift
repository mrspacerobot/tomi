/// Where a cook stands on the rank ladder for their total XP, and how far it is to the next rank.
/// Computed from the cook log on demand, never stored.
public struct Rank: Hashable, Sendable {
    public let title: RankTitle
    /// 1 for every named rank. Past Toque it counts on: Toque II is tier 2.
    public let tier: Int
    public let xp: Int
    /// XP at which this rank began.
    public let startsAt: Int
    /// XP at which the next rank begins. There is always a next rank.
    public let nextAt: Int

    /// The share of the way from this rank to the next, from 0 up to but never reaching 1.
    public var progress: Double {
        Double(xp - startsAt) / Double(nextAt - startsAt)
    }
}
