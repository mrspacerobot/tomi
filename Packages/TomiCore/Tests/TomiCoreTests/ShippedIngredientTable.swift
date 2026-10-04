import Foundation

@testable import TomiCore

/// The ingredient table the app ships, read straight from the app's resources so no simulator is needed.
enum ShippedIngredientTable {
    static let url = URL(filePath: #filePath)
        .deletingLastPathComponent()
        .appending(path: "../../../../Tomi/Resources/Library/ingredients.json")
        .standardized

    static func load() throws -> IngredientTable {
        try IngredientTable.decode(from: Data(contentsOf: url))
    }

    /// The cupboard screen of the mockups (`ob_pantry` in `docs/design/src/round2.py`):
    /// the three locked staples, the ten usual ones and the two typed extras.
    static let mockupStaples: [IngredientID] = [
        "olive-oil", "salt", "black-pepper",
        "rice", "pasta", "flour", "garlic", "onion", "soy-sauce", "stock", "tinned-tomatoes", "butter", "egg",
        "chili-flakes", "sunflower-oil",
    ]

    /// Seared chicken thighs with lemon-butter pan sauce, the sample lesson of the prototype.
    static let searedChickenDish: [IngredientID] = [
        "chicken-thigh", "sunflower-oil", "salt", "garlic", "white-wine", "butter", "lemon", "spinach",
    ]

    /// The spinach and hard-cheese omelette, with either cheese.
    static let omeletteDish: [IngredientID] = [
        "egg", "spinach", "butter", "salt", "black-pepper", "parmesan", "vegetarian-hard-cheese",
    ]
}
