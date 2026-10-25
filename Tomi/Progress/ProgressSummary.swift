import TomiCore

/// What a screen shows of the cook's progress. Worked out from the cook log each time, never stored.
nonisolated struct ProgressSummary: Equatable {
    /// XP, rank and streak, from `GameStateRules`.
    let game: GameState
    /// Per-skill results from the same rules, absent when the menu cannot be read.
    let skillProgress: CookProgress?
    /// Techniques mastered, from `ProgressRules`. Nil when the library has no menu that can be read.
    let masteredCount: Int?
}
