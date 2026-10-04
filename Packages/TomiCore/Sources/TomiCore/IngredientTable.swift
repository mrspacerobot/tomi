/// Everything Tomi knows about who may eat what: the facts an ingredient can have, the things a cook can avoid,
/// the diets a cook can keep, and every ingredient with its facts.
/// It is content, not code: it ships in the lesson library and is read with `decode(from:)`.
/// Diet and allergen answers come only from here. Anything that is not listed is an error or a refusal, never a pass.
public struct IngredientTable: Hashable, Codable, Sendable {
    /// The table layout this build understands. Bump it, and the validator, when the layout changes.
    public static let supportedSchemaVersion = 1

    public let schemaVersion: Int
    /// The closed list of facts. Ingredients, avoid items and diets may only use these.
    public let facts: [IngredientFactID]
    public let avoidItems: [AvoidItem]
    public let diets: [Diet]
    public let ingredients: [Ingredient]

    /// The ingredient with this id. Throws `IngredientTableError.unknownIngredient` when the table has none,
    /// so a caller cannot take a missing ingredient for a harmless one.
    public func ingredient(_ id: IngredientID) throws -> Ingredient {
        guard let ingredient = ingredients.first(where: { $0.id == id }) else {
            throw IngredientTableError.unknownIngredient(id)
        }
        return ingredient
    }

    /// The avoid item with this id, or nil when the table does not list it.
    public func avoidItem(_ id: AvoidItemID) -> AvoidItem? {
        avoidItems.first { $0.id == id }
    }

    /// The diet with this id, or nil when the table does not list it.
    public func diet(_ id: DietID) -> Diet? {
        diets.first { $0.id == id }
    }
}
