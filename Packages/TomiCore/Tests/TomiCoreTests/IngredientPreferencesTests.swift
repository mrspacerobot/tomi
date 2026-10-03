import Testing

@testable import TomiCore

/// Whether one cook may be served an ingredient: their diet and their avoid list must both agree.
@Suite struct IngredientPreferencesTests {
    let garlic = Ingredient.fixture("garlic")
    let butter = Ingredient.fixture("butter", contains: [.dairy])
    let chicken = Ingredient.fixture("chicken", contains: [.meat])
    let wine = Ingredient.fixture("wine", contains: [.alcohol])

    @Test func aCookWithNoRestrictionsIsAllowedEverything() {
        let preferences = CookPreferences()
        #expect(garlic.isAllowed(by: preferences))
        #expect(butter.isAllowed(by: preferences))
        #expect(chicken.isAllowed(by: preferences))
    }

    @Test func theDietAloneCanRefuse() {
        #expect(!chicken.isAllowed(by: .fixture(diet: .vegetarian)))
        #expect(!butter.isAllowed(by: .fixture(diet: .vegan)))
        #expect(butter.isAllowed(by: .fixture(diet: .vegetarian)))
    }

    @Test func theAvoidListAloneCanRefuse() {
        #expect(!butter.isAllowed(by: .fixture(diet: .everything, avoid: [.dairy])))
        #expect(!wine.isAllowed(by: .fixture(diet: .vegan, avoid: [.alcohol])))
        #expect(wine.isAllowed(by: .fixture(diet: .vegan, avoid: [.dairy])))
    }

    @Test func anAvoidedItemIsRefusedEvenWhenTheDietAllowsIt() {
        #expect(!butter.isAllowed(by: .fixture(diet: .vegetarian, avoid: [.nuts, .dairy])))
    }

    @Test func anIngredientOutsideTheDietIsRefusedEvenWhenNothingIsAvoided() {
        let bacon = Ingredient.fixture("bacon", contains: [.pork])
        #expect(!bacon.isAllowed(by: .fixture(diet: .pescatarian)))
        #expect(!bacon.isAllowed(by: .fixture(diet: .everything, avoid: [.pork])))
        #expect(bacon.isAllowed(by: .fixture(diet: .everything, avoid: [.fish])))
    }

    @Test func aPlainPlantIngredientIsAllowedUnderTheStrictestPreferences() {
        #expect(garlic.isAllowed(by: .fixture(diet: .vegan, avoid: Set(AvoidItem.allCases))))
    }
}
