import Testing

/// The fake server's invented quiz carries right choices, so it stays with the UI tests and never ships in the app.
@Suite struct FakeQuizPlacementTests {
    @Test func noFileOfTheAppHoldsARightChoice() throws {
        for path in try Repository.paths(under: "Tomi", ending: ".json") {
            #expect(!(try Repository.text(path)).contains("rightChoice"), "\(path)")
        }
    }

    @Test func theInventedQuizLivesWithTheUITests() throws {
        #expect(try Repository.text("TomiUITests/Fixtures/fake-quiz.json").contains("rightChoice"))
    }
}
