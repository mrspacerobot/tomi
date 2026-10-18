/// What the server worked out for this cook from a graph recipe: the ingredients after its changes,
/// the substitutions and omitted parts that make it safe, what to buy and what to have in the kitchen.
/// Every list is required. A list that is missing must never read as an empty one.
public struct SafePlan: Hashable, Decodable, Sendable {
    public let ingredients: [NamedOption]
    public let substitutions: [OfferSwap]
    /// Parts of the recipe left out for this cook, by the graph's part id, such as `enrichment`.
    public let omittedParts: [String]
    /// Ingredients of the plan the cook did not say they have.
    public let missing: [NamedOption]
    public let equipment: [NamedOption]

    public init(
        ingredients: [NamedOption],
        substitutions: [OfferSwap],
        omittedParts: [String],
        missing: [NamedOption],
        equipment: [NamedOption]
    ) {
        self.ingredients = ingredients
        self.substitutions = substitutions
        self.omittedParts = omittedParts
        self.missing = missing
        self.equipment = equipment
    }
}
