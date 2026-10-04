import Testing

@testable import TomiCore

/// A swap changes the ingredients, so the tags of the swapped lesson are worked out again from the table.
@Suite struct LessonSwapTagsTests {
    let table = IngredientTable.fixture(ingredients: [
        .fixture("garlic"), .fixture("butter", contains: [.dairy]), .fixture("olive-oil"),
        .fixture("bacon", contains: [.pork]),
    ])
    let butterToOliveOil = LessonSwap.fixture(replacing: "butter", with: "olive-oil")

    @Test func swappingButterForOliveOilRemovesDairy() throws {
        let lesson = Lesson.fixture()
        #expect(try !lesson.isAllowed(by: .fixture(diet: .vegan), in: table))
        let swapped = try lesson.applying(butterToOliveOil)
        #expect(swapped.ingredients.map(\.ingredient) == ["garlic", "olive-oil"])
        #expect(try swapped.tags(in: table).avoidItems.isEmpty)
        #expect(try swapped.isAllowed(by: .fixture(diet: .vegan, avoid: [.dairy]), in: table))
    }

    @Test func aSwapCanAlsoTakeADietAway() throws {
        let swapped = try Lesson.fixture().applying(.fixture(replacing: "garlic", with: "bacon"))
        #expect(try swapped.tags(in: table).suitableDiets == [.everything])
        #expect(try swapped.tags(in: table).avoidItems == [.dairy, .pork])
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

    @Test func aSwapToAnIngredientUnknownToTheTableNeverLooksSuitable() throws {
        let swapped = try Lesson.fixture().applying(.fixture(replacing: "butter", with: "dragon-fruit"))
        #expect(throws: IngredientTableError.unknownIngredient("dragon-fruit")) {
            try swapped.isAllowed(by: CookPreferences(), in: table)
        }
    }
}
