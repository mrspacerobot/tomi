import Testing

@testable import TomiCore

/// The computed tags of the two example lessons, worked out from the shipped ingredient table.
@Suite struct ShippedLessonTagsTests {
    @Test func theSearedChickenTeachesTheFirstLevelOfPanSauces() throws {
        let lesson = try ShippedLessons.lesson(ShippedLessons.searedChicken)
        #expect(lesson.skill == "pan-sauce")
        #expect(lesson.level == 1)
    }

    @Test func theSearedChickenIsNotVegetarianAndTriggersDairyAndAlcohol() throws {
        let table = try ShippedIngredientTable.load()
        let lesson = try ShippedLessons.lesson(ShippedLessons.searedChicken)
        let tags = try lesson.tags(in: table)
        #expect(tags.suitableDiets == [])
        #expect(tags.avoidItems == ["dairy", "alcohol"])
        #expect(try lesson.isAllowed(by: .fixture(diet: nil), in: table))
        #expect(try !lesson.isAllowed(by: .fixture(diet: "vegetarian"), in: table))
        #expect(try !lesson.isAllowed(by: .fixture(diet: nil, avoid: ["alcohol"]), in: table))
    }

    @Test func theSearedChickenWithOliveOilForButterIsFreeOfDairy() throws {
        let table = try ShippedIngredientTable.load()
        let lesson = try ShippedLessons.lesson(ShippedLessons.searedChicken)
        let swap = try #require(lesson.swaps.first { $0.ingredient == "butter" })
        #expect(swap.replacement.ingredient == "olive-oil")
        let swapped = try lesson.applying(swap)
        #expect(try swapped.tags(in: table).avoidItems == ["alcohol"])
        #expect(try !lesson.isAllowed(by: .fixture(diet: nil, avoid: ["dairy"]), in: table))
        #expect(try swapped.isAllowed(by: .fixture(diet: nil, avoid: ["dairy"]), in: table))
    }

    @Test func theOmeletteTeachesTheRolledOmelette() throws {
        let lesson = try ShippedLessons.lesson(ShippedLessons.omelette)
        #expect(lesson.skill == "eggs")
        #expect(lesson.level == 3)
    }

    @Test func theOmeletteIsVegetarianNotVeganAndTriggersEggsAndDairy() throws {
        let table = try ShippedIngredientTable.load()
        let lesson = try ShippedLessons.lesson(ShippedLessons.omelette)
        let tags = try lesson.tags(in: table)
        #expect(tags.suitableDiets == ["vegetarian", "pescatarian"])
        #expect(tags.avoidItems == ["eggs", "dairy"])
        #expect(try lesson.isAllowed(by: .fixture(diet: "vegetarian"), in: table))
        #expect(try !lesson.isAllowed(by: .fixture(diet: "vegan"), in: table))
    }

    @Test func theOmeletteUsesTheVegetarianCheeseNotParmesan() throws {
        let ingredients = try ShippedLessons.lesson(ShippedLessons.omelette).ingredients.map(\.ingredient)
        #expect(ingredients.contains("vegetarian-hard-cheese"))
        #expect(!ingredients.contains("parmesan"))
    }
}
