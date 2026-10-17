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

    @Test func listedSwapsAreAppliedInOrderWithTheirOwnAmounts() throws {
        let lesson = Lesson.fixtureWithOliveOilSwap()
        let swapped = try lesson.applying(listed: [AppliedSwap(removed: "butter", added: "olive-oil")])
        #expect(swapped.ingredients == [.fixture("garlic"), .fixture("olive-oil")])
    }

    @Test func aSwapTheLessonDoesNotListIsRefused() {
        let invented = AppliedSwap(removed: "butter", added: "lard")
        #expect(throws: LessonError.swapNotListed(invented)) {
            try Lesson.fixtureWithOliveOilSwap().applying(listed: [invented])
        }
    }

    @Test func noSwapsGiveTheLessonAsWritten() throws {
        #expect(try Lesson.fixture().applying(listed: []) == Lesson.fixture())
    }

    @Test func aSwapOfAnIngredientTheLessonLacksIsAnError() {
        #expect(throws: LessonError.swapOfIngredientNotInLesson("cream")) {
            try Lesson.fixture().applying(.fixture(replacing: "cream", with: "olive-oil"))
        }
    }
}
