import Testing

@testable import TomiCore

/// Applying a swap the lesson lists. Who may eat the result is the server's question, never the app's.
@Suite struct LessonSwapTests {
    let butterToOliveOil = LessonSwap.fixture(replacing: "butter", with: "olive-oil")

    @Test func aSwapReplacesTheIngredientInItsPlace() throws {
        let swapped = try Lesson.fixture().applying(butterToOliveOil)
        #expect(swapped.ingredients.map(\.ingredient) == ["garlic", "olive-oil"])
    }

    @Test func theReplacementBringsItsOwnAmount() throws {
        var swap = butterToOliveOil
        swap.replacement.metric = Amount(15, .millilitre)
        let swapped = try Lesson.fixture().applying(swap)
        #expect(swapped.ingredients[1] == swap.replacement)
        #expect(swapped.ingredients[0] == Lesson.fixture().ingredients[0])
    }

    @Test func applyingASwapLeavesTheLessonItCameFromUntouched() throws {
        let lesson = Lesson.fixture()
        _ = try lesson.applying(butterToOliveOil)
        #expect(lesson == Lesson.fixture())
    }

    @Test func aSwapOfAnIngredientTheLessonLacksIsAnError() {
        #expect(throws: LessonError.swapOfIngredientNotInLesson("cream")) {
            try Lesson.fixture().applying(.fixture(replacing: "cream", with: "olive-oil"))
        }
    }
}
