import Testing

@testable import TomiCore

/// Whether one cook may be served food: their diet and their avoid list must both agree.
@Suite struct IngredientPreferencesTests {
    let table = IngredientTable.fixture()
    let plain: Set<IngredientFactID> = []
    let dairy: Set<IngredientFactID> = ["dairy"]
    let meat: Set<IngredientFactID> = ["meat"]
    let alcohol: Set<IngredientFactID> = ["alcohol"]

    @Test func aCookWithNoRestrictionsIsAllowedEverything() {
        let preferences = CookPreferences()
        #expect(table.allows(plain, for: preferences))
        #expect(table.allows(dairy, for: preferences))
        #expect(table.allows(meat, for: preferences))
    }

    @Test func theDietAloneCanRefuse() {
        #expect(!table.allows(meat, for: .fixture(diet: "vegetarian")))
        #expect(!table.allows(dairy, for: .fixture(diet: "vegan")))
        #expect(table.allows(dairy, for: .fixture(diet: "vegetarian")))
    }

    @Test func theAvoidListAloneCanRefuse() {
        #expect(!table.allows(dairy, for: .fixture(diet: nil, avoid: ["dairy"])))
        #expect(!table.allows(alcohol, for: .fixture(diet: "vegan", avoid: ["alcohol"])))
        #expect(table.allows(alcohol, for: .fixture(diet: "vegan", avoid: ["dairy"])))
    }

    @Test func anAvoidedItemIsRefusedEvenWhenTheDietAllowsIt() {
        #expect(!table.allows(dairy, for: .fixture(diet: "vegetarian", avoid: ["nuts", "dairy"])))
    }

    @Test func foodOutsideTheDietIsRefusedEvenWhenNothingIsAvoided() {
        let pork: Set<IngredientFactID> = ["pork"]
        #expect(!table.allows(pork, for: .fixture(diet: "pescatarian")))
        #expect(!table.allows(pork, for: .fixture(diet: nil, avoid: ["pork"])))
        #expect(table.allows(pork, for: .fixture(diet: nil, avoid: ["dairy"])))
    }

    @Test func foodWithNoFactsIsAllowedUnderTheStrictestPreferences() {
        let everyItem = Set(IngredientTable.fixtureAvoidItems.map(\.id))
        #expect(table.allows(plain, for: .fixture(diet: "vegan", avoid: everyItem)))
    }
}
