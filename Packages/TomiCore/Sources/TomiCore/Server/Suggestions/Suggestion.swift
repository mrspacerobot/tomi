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
    public let teaching: Teaching?

    public var id: RecipeID {
        recipeID
    }

    /// Teaching applies only to the exact recipe the graph authored; changed recipes remain browseable.
    public var canOfferTeaching: Bool {
        teaching != nil && changes.swaps.isEmpty && changes.leftOut.isEmpty
            && safePlan.substitutions.isEmpty && safePlan.omittedParts.isEmpty
    }

    enum CodingKeys: String, CodingKey {
        case recipeID = "recipeId"
        case title, recipe, changes, skill, level, safePlan, reason, checked, teaching
    }

    public init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        recipeID = try values.decode(RecipeID.self, forKey: .recipeID)
        title = try values.decode(String.self, forKey: .title)
        recipe = try values.decode(AdaptedRecipe.self, forKey: .recipe)
        changes = try values.decode(RecipeChanges.self, forKey: .changes)
        skill = try values.decode(SuggestionSkill.self, forKey: .skill)
        level = try values.decode(NamedLevel.self, forKey: .level)
        safePlan = try values.decode(SafePlan.self, forKey: .safePlan)
        (reason, checked) = try Self.reasonAndCheck(values)
        teaching = try? values.decodeIfPresent(Teaching.self, forKey: .teaching)
    }

    private static func reasonAndCheck(
        _ values: KeyedDecodingContainer<CodingKeys>
    ) throws -> (String?, CheckedRestrictions) {
        let reason = try? values.decodeIfPresent(String.self, forKey: .reason)
        let checked = try values.decode(CheckedRestrictions.self, forKey: .checked)
        return (reason ?? nil, checked)
    }
}
