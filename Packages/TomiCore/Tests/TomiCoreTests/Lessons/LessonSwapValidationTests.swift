import Testing

@testable import TomiCore

@Suite struct LessonSwapValidationTests {
    @Test func aSwapOfAnIngredientOfTheLessonForAnotherIsValid() {
        var lesson = Lesson.fixture()
        lesson.swaps = [.fixture(replacing: "butter", with: "bacon")]
        #expect(lesson.issuesInTheFixtureLibrary().isEmpty)
    }

    @Test func aSwapMustReplaceAnIngredientOfTheLesson() {
        var lesson = Lesson.fixture()
        lesson.swaps = [.fixture(replacing: "cream", with: "bacon")]
        #expect(lesson.issuesInTheFixtureLibrary() == [.swapOfIngredientNotInLesson("cream")])
    }

    @Test(arguments: ["garlic", "butter"] as [IngredientID])
    func aReplacementIsNotAlreadyInTheLesson(replacement: IngredientID) {
        var lesson = Lesson.fixture()
        lesson.swaps = [.fixture(replacing: "butter", with: replacement)]
        #expect(lesson.issuesInTheFixtureLibrary() == [.swapReplacementAlreadyInLesson(replacement)])
    }

    @Test func aReplacementHasProperAmountsToo() {
        var lesson = Lesson.fixture()
        var swap = LessonSwap.fixture(replacing: "butter", with: "bacon")
        swap.replacement.metric = Amount(0, .gram)
        swap.replacement.cups = Amount(1, .millilitre)
        lesson.swaps = [swap]
        let expected: [LessonIssue] = [.amountNotPositive("bacon", .metric), .unitOutsideSystem("bacon", .cups)]
        #expect(lesson.issuesInTheFixtureLibrary() == expected)
    }
}
