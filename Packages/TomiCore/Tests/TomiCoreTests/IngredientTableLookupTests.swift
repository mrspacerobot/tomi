import Testing

@testable import TomiCore

/// The table answers by id, and an id it does not know is an error, never a pass.
@Suite struct IngredientTableLookupTests {
    let table = IngredientTable.fixture()

    @Test func aKnownIngredientIsFound() throws {
        #expect(try table.ingredient("butter") == .fixture("butter", contains: [.dairy]))
    }

    @Test func theTableAnswersForAKnownIngredient() throws {
        #expect(try table.allowingDiets(for: "butter") == [.everything, .vegetarian, .pescatarian])
        #expect(try table.avoidItems(for: "bacon") == [.pork])
        #expect(try table.isAllowed("garlic", by: .fixture(diet: .vegan)))
        #expect(try !table.isAllowed("butter", by: .fixture(diet: .vegan)))
    }

    @Test func lookingUpAnUnknownIngredientIsAnError() {
        #expect(throws: IngredientTableError.unknownIngredient("dragon-fruit")) {
            try table.ingredient("dragon-fruit")
        }
    }

    @Test func anUnknownIngredientHasNoDiets() {
        #expect(throws: IngredientTableError.unknownIngredient("dragon-fruit")) {
            try table.allowingDiets(for: "dragon-fruit")
        }
    }

    @Test func anUnknownIngredientHasNoAvoidItems() {
        #expect(throws: IngredientTableError.unknownIngredient("dragon-fruit")) {
            try table.avoidItems(for: "dragon-fruit")
        }
    }

    @Test func anUnknownIngredientIsNeverAllowed() {
        #expect(throws: IngredientTableError.unknownIngredient("dragon-fruit")) {
            try table.isAllowed("dragon-fruit", by: CookPreferences())
        }
    }

    @Test func idsAreMatchedExactly() {
        #expect(throws: IngredientTableError.unknownIngredient("Butter")) {
            try table.ingredient("Butter")
        }
    }
}
