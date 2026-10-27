import Testing

/// The fake server answers progress from fixtures and computes nothing, or the game rules would come back into the
/// app through it. The rule reads the fake's files as text, because the rules package cannot import the app.
@Suite struct FakeServerRuleTests {
    /// Every type and call of TomiCore that works out XP, rank, streak or progress.
    static let gameRules = [
        "GameRules", "GameStateRules", "StreakRules", "ProgressRules", "Rank(", "Rank.", "RankTitle", "earnedXP",
        "CookingWeek", "CompletedCook", "masteredCount(",
    ]

    @Test func theFakeServerNamesNoGameRule() throws {
        let fakes = try Repository.swiftFiles(under: "Tomi/Backend").filter { $0.path.contains("/Fake") }
        #expect(fakes.count >= 10)
        var found: [String] = []
        for file in fakes {
            for rule in Self.gameRules where file.codeLines.contains(where: { $0.contains(rule) }) {
                found.append(file.path + " names " + rule)
            }
        }
        #expect(found == [])
    }
}
