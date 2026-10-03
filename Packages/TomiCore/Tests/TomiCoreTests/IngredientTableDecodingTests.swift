import Foundation
import Testing

@testable import TomiCore

@Suite struct IngredientTableDecodingTests {
    static let garlic = #"{"id": "garlic", "name": {"en": "Garlic"}, "contains": []}"#

    @Test func aValidTableDecodes() throws {
        let soySauce = #"{"id": "soy-sauce", "name": {"en": "Soy sauce"}, "contains": ["soy", "gluten"]}"#
        let table = try IngredientTable.decode(from: json(ingredients: "[\(Self.garlic), \(soySauce)]"))
        #expect(table.ingredients.map(\.id) == ["garlic", "soy-sauce"])
        #expect(try table.ingredient("soy-sauce").facts == [.soy, .gluten])
        #expect(try table.ingredient("garlic").name.resolved(preferredLanguages: []) == "Garlic")
    }

    @Test func aTableSurvivesARoundTripThroughJSON() throws {
        let table = IngredientTable.fixture()
        #expect(try IngredientTable.decode(from: JSONEncoder().encode(table)) == table)
    }

    @Test(arguments: [0, IngredientTable.supportedSchemaVersion + 1])
    func anUnknownSchemaVersionIsRejectedBeforeReadingTheRest(version: Int) {
        #expect(throws: IngredientTableError.unsupportedSchemaVersion(version)) {
            try IngredientTable.decode(from: json(schemaVersion: version, ingredients: #""a shape from the future""#))
        }
    }

    @Test(arguments: [#"{"ingredients": []}"#, "not json", ""])
    func aFileWithoutASchemaVersionIsRejected(file: String) {
        #expect(throws: DecodingError.self) {
            try IngredientTable.decode(from: Data(file.utf8))
        }
    }

    @Test(arguments: [
        #"{"id": "garlic", "name": {"en": "Garlic"}}"#,
        #"{"id": "garlic", "contains": []}"#,
        #"{"name": {"en": "Garlic"}, "contains": []}"#,
    ])
    func anIngredientMissingAFieldIsRejectedRatherThanTakenAsPlain(ingredient: String) {
        #expect(throws: DecodingError.self) {
            try IngredientTable.decode(from: json(ingredients: "[\(ingredient)]"))
        }
    }

    @Test(arguments: ["allergens", "avoid", "contain"])
    func aFieldThisBuildDoesNotReadIsRejectedRatherThanIgnored(field: String) {
        let ingredient = #"{"id": "satay", "name": {"en": "Satay"}, "contains": [], "\#(field)": ["nuts"]}"#
        #expect(throws: DecodingError.self) {
            try IngredientTable.decode(from: json(ingredients: "[\(ingredient)]"))
        }
    }

    @Test func aFactThatIsNotOnTheClosedListIsRejectedNotDropped() {
        let satay = #"{"id": "satay", "name": {"en": "Satay"}, "contains": ["soy", "peanuts", "eggs"]}"#
        let issues: [IngredientIssue] = [.unknownFact("satay", "peanuts"), .unknownFact("satay", "eggs")]
        #expect(throws: IngredientTableError.invalid(issues)) {
            try IngredientTable.decode(from: json(ingredients: "[\(Self.garlic), \(satay)]"))
        }
    }

    @Test func anInvalidTableIsRejectedWithItsIssues() {
        #expect(throws: IngredientTableError.invalid([.duplicateIngredient("garlic")])) {
            try IngredientTable.decode(from: json(ingredients: "[\(Self.garlic), \(Self.garlic)]"))
        }
    }

    private func json(schemaVersion: Int = IngredientTable.supportedSchemaVersion, ingredients: String) -> Data {
        Data(#"{"schemaVersion": \#(schemaVersion), "ingredients": \#(ingredients)}"#.utf8)
    }
}
