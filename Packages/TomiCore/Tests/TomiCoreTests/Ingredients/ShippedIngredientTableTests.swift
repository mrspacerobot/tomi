import Foundation
import Testing

@testable import TomiCore

/// Checks the ingredient table the app ships, so a content mistake fails here without needing the simulator.
@Suite struct ShippedIngredientTableTests {
    @Test func theShippedTableIsValid() throws {
        let table = try ShippedIngredientTable.load()
        #expect(!table.ingredients.isEmpty)
    }

    @Test func everyShippedIngredientHasADistinctName() throws {
        let table = try ShippedIngredientTable.load()
        let names = table.ingredients.map { $0.name.resolved(preferredLanguages: ["en"]) }
        #expect(Set(names).count == names.count)
    }

    @Test(arguments: ShippedIngredientTable.mockupStaples)
    func everyCupboardStapleOfTheMockupsIsInTheTable(staple: IngredientID) throws {
        let table = try ShippedIngredientTable.load()
        #expect(throws: Never.self) {
            try table.ingredient(staple)
        }
    }

    @Test(arguments: ShippedIngredientTable.searedChickenDish + ShippedIngredientTable.omeletteDish)
    func everyIngredientOfTheExampleDishesIsInTheTable(ingredient: IngredientID) throws {
        let table = try ShippedIngredientTable.load()
        #expect(throws: Never.self) {
            try table.ingredient(ingredient)
        }
    }

    @Test func theCupboardOfTheMockupsCanBeSavedAsPreferences() throws {
        let table = try ShippedIngredientTable.load()
        var preferences = CookPreferences()
        preferences.cupboardStaples = Set(ShippedIngredientTable.mockupStaples)
        let known = Set(table.ingredients.map(\.id))
        #expect(preferences.cupboardStaples.isSubset(of: known))
    }

    @Test func anIngredientThatIsNotShippedIsStillAnError() throws {
        let table = try ShippedIngredientTable.load()
        #expect(throws: IngredientTableError.unknownIngredient("unicorn-steak")) {
            try table.isAllowed("unicorn-steak", by: CookPreferences())
        }
    }
}
