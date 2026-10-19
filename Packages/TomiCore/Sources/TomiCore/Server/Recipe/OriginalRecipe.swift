/// The graph's recipe exactly as the graph wrote it, in the graph's own words and amounts.
/// It is not rewritten when the safe plan changes an ingredient or leaves a part out, so it is never
/// "adapted": the cook reads the safe plan beside it.
public struct OriginalRecipe: Hashable, Decodable, Sendable {
    public let ingredients: [RecipeIngredient]
    public let steps: [RecipeStep]
    public let equipment: [OptionID]
    /// How much the original recipe makes, or nil when it does not say.
    public let yields: RecipeAmount?

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        ingredients = try container.decode([RecipeIngredient].self, forKey: .ingredients)
        steps = try container.decode([RecipeStep].self, forKey: .steps)
        equipment = try container.decode([OptionID].self, forKey: .equipment)
        yields = try container.decodeIfPresent(RecipeAmount.self, forKey: .yields)
    }

    enum CodingKeys: String, CodingKey {
        case ingredients, steps, equipment, yields
    }
}
