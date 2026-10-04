@testable import TomiCore

extension IngredientTable {
    /// A plant, a dairy product and a pork product.
    static let fixtureIngredients: [Ingredient] = [
        .fixture("garlic"),
        .fixture("butter", contains: [.dairy]),
        .fixture("bacon", contains: [.pork]),
    ]

    /// A valid table of three ingredients. Each test breaks it in one way.
    static func fixture(ingredients: [Ingredient] = fixtureIngredients) -> IngredientTable {
        IngredientTable(schemaVersion: IngredientTable.supportedSchemaVersion, ingredients: ingredients)
    }
}
