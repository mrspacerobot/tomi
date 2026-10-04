@testable import TomiCore

extension LessonIngredient {
    /// Thirty grams, or two tablespoons, of the ingredient.
    static func fixture(_ id: IngredientID) -> LessonIngredient {
        LessonIngredient(ingredient: id, metric: Amount(30, .gram), cups: Amount(2, .tablespoon))
    }
}

extension LessonSwap {
    static func fixture(replacing ingredient: IngredientID, with replacement: IngredientID) -> LessonSwap {
        LessonSwap(ingredient: ingredient, replacement: .fixture(replacement))
    }
}
