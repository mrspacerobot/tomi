import Foundation
import Testing

@testable import TomiCore

/// The lists a cook chooses from are read as strictly as the ingredients.
@Suite struct IngredientRestrictionDecodingTests {
    @Test func avoidItemsAndDietsDecode() throws {
        let table = try IngredientTable.decode(from: IngredientTableFile().data)
        #expect(table.facts == ["soy", "gluten", "meat"])
        #expect(table.avoidItem("soy")?.triggeredBy == ["soy"])
        #expect(table.diet("vegan")?.excludes == ["meat"])
        #expect(table.diet("vegan")?.summary.resolved(preferredLanguages: []) == "Plants")
    }

    @Test func aTableMayOfferNoAvoidItemsAndNoDiets() throws {
        var file = IngredientTableFile()
        file.avoidItems = "[]"
        file.diets = "[]"
        let table = try IngredientTable.decode(from: file.data)
        #expect(table.understands(CookPreferences()))
        #expect(!table.understands(.fixture(diet: "vegan")))
    }

    @Test(arguments: ["facts", "avoidItems", "diets"])
    func aTableMissingOneOfItsListsIsRejected(list: String) throws {
        let whole = try #require(String(data: IngredientTableFile().data, encoding: .utf8))
        let renamed = whole.replacingOccurrences(of: "\"\(list)\":", with: "\"other\":")
        #expect(throws: DecodingError.self) {
            try IngredientTable.decode(from: Data(renamed.utf8))
        }
    }

    @Test func anAvoidItemWithAFieldThisBuildDoesNotReadIsRejected() {
        var file = IngredientTableFile()
        file.avoidItems = #"[{"id": "soy", "name": {"en": "Soy"}, "triggeredBy": ["soy"], "facts": ["gluten"]}]"#
        #expect(throws: DecodingError.self) {
            try IngredientTable.decode(from: file.data)
        }
    }

    @Test func aDietWithAFieldThisBuildDoesNotReadIsRejected() {
        var file = IngredientTableFile()
        file.diets = #"[{"id": "vegan", "name": {"en": "Vegan"}, "summary": {"en": "Plants"}, "exclude": ["meat"]}]"#
        #expect(throws: DecodingError.self) {
            try IngredientTable.decode(from: file.data)
        }
    }

    @Test func aDietThatUsesAnUndeclaredFactIsRejected() {
        var file = IngredientTableFile()
        file.diets = #"[{"id": "vegan", "name": {"en": "V"}, "summary": {"en": "P"}, "excludes": ["meet"]}]"#
        #expect(throws: IngredientTableError.invalid([.undeclaredDietFact("vegan", "meet")])) {
            try IngredientTable.decode(from: file.data)
        }
    }
}
