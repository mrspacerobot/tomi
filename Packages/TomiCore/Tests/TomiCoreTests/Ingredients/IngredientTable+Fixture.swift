@testable import TomiCore

extension IngredientTable {
    static let fixtureFacts: [IngredientFactID] = ["meat", "pork", "fish", "dairy", "egg", "alcohol", "nuts"]

    /// A plant, a dairy product and a pork product.
    static let fixtureIngredients: [Ingredient] = [
        .fixture("garlic"),
        .fixture("butter", contains: ["dairy"]),
        .fixture("bacon", contains: ["pork"]),
    ]

    /// Each avoid item is triggered by the fact of the same name. Meat, fish and egg trigger none.
    static let fixtureAvoidItems: [AvoidItem] = [
        .fixture("dairy", triggeredBy: ["dairy"]),
        .fixture("pork", triggeredBy: ["pork"]),
        .fixture("nuts", triggeredBy: ["nuts"]),
        .fixture("alcohol", triggeredBy: ["alcohol"]),
    ]

    static let fixtureDiets: [Diet] = [
        .fixture("vegetarian", excludes: ["meat", "pork", "fish"]),
        .fixture("vegan", excludes: ["meat", "pork", "fish", "dairy", "egg"]),
        .fixture("pescatarian", excludes: ["meat", "pork"]),
    ]

    /// A valid table. Each test breaks it in one way.
    static func fixture(ingredients: [Ingredient] = fixtureIngredients) -> IngredientTable {
        IngredientTable(
            schemaVersion: IngredientTable.supportedSchemaVersion,
            facts: fixtureFacts,
            avoidItems: fixtureAvoidItems,
            diets: fixtureDiets,
            ingredients: ingredients
        )
    }
}
