/// What the table says about a set of ingredient facts, and about one cook.
/// Nothing here is written in the file per ingredient: it is all worked out from the facts,
/// so the avoid list and the diets can never disagree with each other.
extension IngredientTable {
    /// The avoid items that food with these facts triggers.
    public func avoidItems(triggeredBy facts: Set<IngredientFactID>) -> Set<AvoidItemID> {
        var triggered: Set<AvoidItemID> = []
        for item in avoidItems where !item.triggeredBy.isDisjoint(with: facts) {
            triggered.insert(item.id)
        }
        return triggered
    }

    /// The diets that allow food with these facts. A cook with no diet is always allowed, and is not listed here.
    public func diets(allowing facts: Set<IngredientFactID>) -> Set<DietID> {
        var allowing: Set<DietID> = []
        for diet in diets where diet.excludes.isDisjoint(with: facts) {
            allowing.insert(diet.id)
        }
        return allowing
    }

    /// Whether this cook may be served food with these facts.
    /// A diet or avoid item the table does not list refuses everything: it may be a restriction saved by a newer
    /// app, or one that could not be read, and serving anything would risk ignoring it.
    public func allows(_ facts: Set<IngredientFactID>, for preferences: CookPreferences) -> Bool {
        guard dietAllows(facts, diet: preferences.diet) else {
            return false
        }
        return avoidListAllows(facts, avoid: preferences.avoid)
    }

    /// Whether the table lists the cook's diet and every item they avoid. When it does not, nothing is served,
    /// and the app should ask the cook to update or to answer again.
    public func understands(_ preferences: CookPreferences) -> Bool {
        let noFacts: Set<IngredientFactID> = []
        return allows(noFacts, for: preferences)
    }

    private func avoidListAllows(_ facts: Set<IngredientFactID>, avoid: Set<AvoidItemID>) -> Bool {
        for avoidedID in avoid {
            guard let avoided = avoidItem(avoidedID) else {
                return false
            }
            if !avoided.triggeredBy.isDisjoint(with: facts) {
                return false
            }
        }
        return true
    }

    private func dietAllows(_ facts: Set<IngredientFactID>, diet dietID: DietID?) -> Bool {
        guard let dietID else {
            return true
        }
        guard let diet = diet(dietID) else {
            return false
        }
        return diet.excludes.isDisjoint(with: facts)
    }
}
