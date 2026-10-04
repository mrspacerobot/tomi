@testable import TomiCore

/// The fixture table with one of its lists replaced, for tests that break the things a cook can choose.
extension IngredientTable {
    func with(facts: [IngredientFactID]) -> IngredientTable {
        IngredientTable(
            schemaVersion: schemaVersion,
            facts: facts,
            avoidItems: avoidItems,
            diets: diets,
            ingredients: ingredients
        )
    }

    func with(avoidItems: [AvoidItem]) -> IngredientTable {
        IngredientTable(
            schemaVersion: schemaVersion,
            facts: facts,
            avoidItems: avoidItems,
            diets: diets,
            ingredients: ingredients
        )
    }

    func with(diets: [Diet]) -> IngredientTable {
        IngredientTable(
            schemaVersion: schemaVersion,
            facts: facts,
            avoidItems: avoidItems,
            diets: diets,
            ingredients: ingredients
        )
    }
}
