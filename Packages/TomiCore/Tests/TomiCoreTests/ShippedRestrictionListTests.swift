import Testing

@testable import TomiCore

/// The avoid items and diets the shipped table offers, and the invariants a new diet is easy to get wrong.
@Suite struct ShippedRestrictionListTests {
    @Test func theShippedListsAreTheOnesTheMockupsOffer() throws {
        let table = try ShippedIngredientTable.load()
        let avoidItems: [AvoidItemID] = [
            "nuts", "dairy", "gluten", "eggs", "shellfish", "fish", "soy", "sesame", "pork", "alcohol",
        ]
        #expect(table.avoidItems.map(\.id) == avoidItems)
        #expect(table.diets.map(\.id) == ["vegetarian", "vegan", "pescatarian"])
    }

    @Test func everyShippedDietThatRulesOutMeatRulesOutPorkAndSlaughterProductsToo() throws {
        let table = try ShippedIngredientTable.load()
        for diet in table.diets where diet.excludes.contains("meat") {
            #expect(diet.excludes.isSuperset(of: ["pork", "slaughterProduct"]), "\(diet.id.rawValue)")
        }
    }

    @Test func theVeganDietRulesOutEverythingTheVegetarianDoes() throws {
        let table = try ShippedIngredientTable.load()
        let vegetarian = try #require(table.diet("vegetarian"))
        let vegan = try #require(table.diet("vegan"))
        #expect(vegan.excludes.isStrictSuperset(of: vegetarian.excludes))
    }
}
