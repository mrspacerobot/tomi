import Foundation

/// Works out the game state from the cook log, so screens ask one place for XP, rank and streak.
public struct GameStateRules: Sendable {
    /// The cook's own calendar (`Calendar.current` in the app), which the streak needs to tell weeks apart.
    public let calendar: Calendar

    public init(calendar: Calendar) {
        self.calendar = calendar
    }

    /// The game state at `now`, from the cook log and the cook's current weekly goal.
    /// Entries may come in any order and may repeat.
    public func gameState(for entries: [CookEntry], goal: Int, now: Date) -> GameState {
        let xp = entries.earnedXP
        let streak = StreakRules(calendar: calendar).streak(for: entries.completedCooks, goal: goal, now: now)
        return GameState(xp: xp, rank: Rank.forXP(xp), streak: streak)
    }
}
