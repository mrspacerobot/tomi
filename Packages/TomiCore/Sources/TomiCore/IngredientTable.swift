/// Every ingredient Tomi knows, with the facts that decide diets and the avoid list.
/// It is content, not code: it ships in the lesson library and is read with `decode(from:)`.
/// Diet and allergen answers come only from here. An ingredient that is not listed is an error, never a pass.
public struct IngredientTable: Hashable, Codable, Sendable {
    /// The table layout this build understands. Bump it, and the validator, when the layout changes.
    public static let supportedSchemaVersion = 1

    public let schemaVersion: Int
    public let ingredients: [Ingredient]

    /// The ingredient with this id. Throws `IngredientTableError.unknownIngredient` when the table has none,
    /// so a caller cannot take a missing ingredient for a harmless one.
    public func ingredient(_ id: IngredientID) throws -> Ingredient {
        guard let ingredient = ingredients.first(where: { $0.id == id }) else {
            throw IngredientTableError.unknownIngredient(id)
        }
        return ingredient
    }

    public func allowingDiets(for id: IngredientID) throws -> Set<Diet> {
        try ingredient(id).allowingDiets
    }

    public func avoidItems(for id: IngredientID) throws -> Set<AvoidItem> {
        try ingredient(id).avoidItems
    }

    public func isAllowed(_ id: IngredientID, by preferences: CookPreferences) throws -> Bool {
        try ingredient(id).isAllowed(by: preferences)
    }
}
