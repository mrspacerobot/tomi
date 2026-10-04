/// Where the cook stands in the game at one moment: total XP, the rank it gives, and the weekly streak.
/// Computed from the cook log on demand by `GameStateRules`, never stored.
public struct GameState: Hashable, Sendable {
    /// Total XP earned by every finished cook in the log.
    public let xp: Int
    public let rank: Rank
    public let streak: Streak
}
