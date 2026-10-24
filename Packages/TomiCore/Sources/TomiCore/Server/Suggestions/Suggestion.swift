/// One dish the server suggests for tonight: a recipe of the cooking graph, already adapted for this cook.
/// `recipe` is the one the cook follows and `changes` says what differs from the graph's own. The safe plan still
/// carries what to buy and the equipment, and `checked` says for which diet and avoid list the server decided it.
/// The graph's original recipe (`sourceRecipe`) is sent too and is not read: a suggestion shows one recipe.
public struct Suggestion: Identifiable, Hashable, Decodable, Sendable {
    public let recipeID: RecipeID
    public let title: String
    public let recipe: AdaptedRecipe
    public let changes: RecipeChanges
    public let skill: SuggestionSkill
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
        case title, recipe, changes, skill, level, safePlan, reason, checked
    }
}
