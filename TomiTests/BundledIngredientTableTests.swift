import Foundation
import Testing
import TomiCore

@testable import Tomi

@Suite struct BundledIngredientTableTests {
    @Test func theIngredientTableShipsInTheAppAndIsValid() throws {
        let table = try IngredientTable.decode(from: BundledLibrary.ingredientTableData())
        #expect(!table.ingredients.isEmpty)
        #expect(BundledLibrary.ingredientTable() == table)
    }

    @Test func everyIngredientReadsInTheCooksLanguage() throws {
        let table = try #require(BundledLibrary.ingredientTable())
        for ingredient in table.ingredients {
            #expect(!ingredient.name.resolved(preferredLanguages: Locale.preferredLanguages).isEmpty)
        }
    }

    @Test func aMissingTableGivesNoTable() throws {
        #expect(BundledLibrary.ingredientTable(in: try Bundle.fixture(ingredients: nil)) == nil)
    }

    @Test(arguments: ["", "not json", #"{"schemaVersion": 99}"#, #"{"schemaVersion": 1}"#])
    func anUnreadableTableGivesNoTable(contents: String) throws {
        let bundle = try Bundle.fixture(ingredients: Data(contents.utf8))
        #expect(BundledLibrary.ingredientTable(in: bundle) == nil)
    }

    @Test(arguments: [
        "",
        #"{"id": "satay", "name": {"en": "Satay"}, "contains": ["peanuts"]}"#,
        #"{"id": "garlic", "name": {"en": "Garlic"}}"#,
    ])
    func aTableWithNoIngredientsOrAWrongOneGivesNoTable(ingredients: String) throws {
        let contents = #"{"schemaVersion": 1, "ingredients": [\#(ingredients)]}"#
        let bundle = try Bundle.fixture(ingredients: Data(contents.utf8))
        #expect(BundledLibrary.ingredientTable(in: bundle) == nil)
    }

    @Test func aValidTableInAnyBundleIsRead() throws {
        let bundle = try Bundle.fixture(ingredients: BundledLibrary.ingredientTableData())
        #expect(BundledLibrary.ingredientTable(in: bundle) == BundledLibrary.ingredientTable())
    }
}
