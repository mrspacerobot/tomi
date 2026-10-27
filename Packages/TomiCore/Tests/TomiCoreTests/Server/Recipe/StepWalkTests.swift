import Testing

@testable import TomiCore

/// Walking the adapted recipe one step at a time: where the cook is, and never past either end.
@Suite struct StepWalkTests {
    func walk() throws -> StepWalk {
        let steps = try ServerJSON.decode(Suggestion.self, from: GraphJSON.suggestion()).recipe.steps
        return try #require(StepWalk(steps: steps))
    }

    @Test func theWalkStartsAtTheFirstStep() throws {
        let walk = try walk()
        #expect(walk.current.number == 1)
        #expect(walk.position == 1)
        #expect(walk.count == 3)
        #expect(walk.isFirst)
        #expect(!walk.isLast)
    }

    @Test func advancingMovesOneStepAndKeepsTheServerOrder() throws {
        let second = try walk().advanced()
        #expect(second.current.text == "Stir the eggs in the oil over low heat.")
        #expect(second.position == 2)
        #expect(!second.isFirst)
        #expect(!second.isLast)
    }

    @Test func theLastStepIsReportedAndAdvancingStaysThere() throws {
        let last = try walk().advanced().advanced()
        #expect(last.isLast)
        #expect(last.advanced() == last)
    }

    @Test func steppingBackReturnsToTheStepBeforeAndStopsAtTheFirst() throws {
        let walk = try walk()
        #expect(walk.advanced().steppedBack() == walk)
        #expect(walk.steppedBack() == walk)
    }

    @Test func aStepKeepsWhatTheServerSaidAboutIt() throws {
        let middle = try walk().advanced().current
        #expect(middle.time == StepTime(shortest: 4, longest: 6, unit: "minute"))
        #expect(middle.safetyPoints == ["raw-or-lightly-cooked-egg"])
    }

    @Test func aRecipeWithNoStepsCannotBeWalked() {
        #expect(StepWalk(steps: []) == nil)
    }
}
