import Testing

@testable import TomiCore

/// Diets and avoid items are never written in a lesson: they are worked out from its ingredients.
@Suite struct LessonTagsTests {
    static let everyone: Set<Diet> = [.everything, .vegetarian, .vegan, .pescatarian]
    let table = IngredientTable.fixture()

    @Test func aLessonOfPlantsSuitsEveryoneAndTriggersNothing() throws {
        var lesson = Lesson.fixture()
        lesson.ingredients = [.fixture("garlic")]
        let tags = try lesson.tags(in: table)
        #expect(tags.suitableDiets == Self.everyone)
        #expect(tags.avoidItems.isEmpty)
    }

    @Test func oneIngredientIsEnoughToRuleOutADiet() throws {
        let tags = try Lesson.fixture().tags(in: table)
        #expect(tags.suitableDiets == [.everything, .vegetarian, .pescatarian])
        #expect(tags.avoidItems == [.dairy])
    }

    @Test func theTagsAddUpOverEveryIngredient() throws {
        var lesson = Lesson.fixture()
        lesson.ingredients.append(.fixture("bacon"))
        let tags = try lesson.tags(in: table)
        #expect(tags.suitableDiets == [.everything])
        #expect(tags.avoidItems == [.dairy, .pork])
    }

    @Test func aCookIsShownOnlyWhatTheirDietAndAvoidListAllow() throws {
        let lesson = Lesson.fixture()
        #expect(try lesson.isAllowed(by: .fixture(diet: .everything), in: table))
        #expect(try lesson.isAllowed(by: .fixture(diet: .vegetarian, avoid: [.nuts]), in: table))
        #expect(try !lesson.isAllowed(by: .fixture(diet: .vegan), in: table))
        #expect(try !lesson.isAllowed(by: .fixture(diet: .everything, avoid: [.dairy]), in: table))
    }

    @Test func anIngredientUnknownToTheTableIsAnErrorNeverSuitable() {
        var lesson = Lesson.fixture()
        lesson.ingredients.append(.fixture("dragon-fruit"))
        #expect(throws: IngredientTableError.unknownIngredient("dragon-fruit")) {
            try lesson.tags(in: table)
        }
        #expect(throws: IngredientTableError.unknownIngredient("dragon-fruit")) {
            try lesson.isAllowed(by: CookPreferences(), in: table)
        }
    }
}
