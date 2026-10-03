@testable import TomiCore

extension Ingredient {
    /// An ingredient with an English name. No facts means a plain plant ingredient.
    static func fixture(_ id: IngredientID, contains facts: Set<IngredientFact> = []) -> Ingredient {
        Ingredient(id: id, name: LocalizedText(["en": "Ingredient \(id.rawValue)"]), facts: facts)
    }

    func with(name: LocalizedText) -> Ingredient {
        Ingredient(id: id, name: name, facts: facts)
    }
}
