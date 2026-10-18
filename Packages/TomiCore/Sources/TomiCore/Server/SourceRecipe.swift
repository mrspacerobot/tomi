/// The graph's recipe exactly as the graph wrote it, in the graph's own words and amounts.
/// It is not rewritten when the safe plan changes an ingredient or leaves a part out, so it is never
/// "adapted": the cook reads the safe plan beside it.
public struct SourceRecipe: Hashable, Decodable, Sendable {
    public let ingredients: [SourceLine]
    public let steps: [SourceStep]
    public let equipment: [OptionID]
    /// How much the source recipe makes, or nil when it does not say.
    public let yields: SourceAmount?

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        ingredients = try container.decode([SourceLine].self, forKey: .ingredients)
        steps = try container.decode([SourceStep].self, forKey: .steps)
        equipment = try container.decode([OptionID].self, forKey: .equipment)
        yields = try? container.decodeIfPresent(SourceAmount.self, forKey: .yields)
    }

    enum CodingKeys: String, CodingKey {
        case ingredients, steps, equipment, yields
    }
}
