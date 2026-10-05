import TomiCore

/// What a screen shows of the cook's progress. Worked out from the cook log each time, never stored.
nonisolated struct ProgressSummary: Equatable {
    /// XP, rank and streak, from `GameStateRules`.
    let game: GameState
    /// Techniques mastered, from `ProgressRules`. Nil when the library has no menu that can be read.
    let masteredCount: Int?
    /// Whether the cook has been through onboarding. A cook who has not sees it before anything else.
    let isOnboardingDone: Bool
}
