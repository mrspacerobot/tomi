/// One dish the server offers for tonight: a recipe of the cooking graph, with the safe plan for this cook.
/// The source recipe is the graph's own text, never rewritten. The safe plan says what changes for this cook,
/// and `checked` says for which diet and avoid list the server decided it.
public struct Offer: Identifiable, Hashable, Decodable, Sendable {
    public let recipeID: RecipeID
    public let title: String
    public let sourceRecipe: SourceRecipe
    public let skill: OfferSkill
    public let level: NamedLevel
    public let safePlan: SafePlan
    /// One line from the server's model about why this dish, or nil when it ranked without one.
    public let reason: String?
    public let checked: CheckedRestrictions

    public var id: RecipeID {
        recipeID
    }

    enum CodingKeys: String, CodingKey {
        case recipeID = "recipeId"
        case title, sourceRecipe, skill, level, safePlan, reason, checked
    }
}
