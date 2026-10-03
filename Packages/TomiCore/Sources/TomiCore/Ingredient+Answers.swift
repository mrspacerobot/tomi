/// What the facts of an ingredient mean for a cook. Nothing here is written in the file: it is all worked out
/// from `facts`, so the avoid list and the diets can never disagree with each other.
extension Ingredient {
    /// The avoid-list items this ingredient triggers.
    public var avoidItems: Set<AvoidItem> {
        var items: Set<AvoidItem> = []
        for fact in facts {
            if let item = fact.avoidItem {
                items.insert(item)
            }
        }
        return items
    }

    /// The diets that allow this ingredient: the ones every one of its facts allows.
    /// An ingredient with a fact this build cannot read suits no diet at all.
    public var allowingDiets: Set<Diet> {
        guard unknownFacts.isEmpty else {
            return []
        }
        var diets = Set(Diet.allCases)
        for fact in facts {
            diets.formIntersection(fact.allowingDiets)
        }
        return diets
    }

    /// Meat of any kind. Pork counts without `meat` being written next to it.
    public var isMeat: Bool {
        facts.contains(.meat) || facts.contains(.pork)
    }

    /// Whether this cook may be served the ingredient: their diet allows it and it triggers nothing they avoid.
    public func isAllowed(by preferences: CookPreferences) -> Bool {
        guard allowingDiets.contains(preferences.diet) else {
            return false
        }
        return avoidItems.isDisjoint(with: preferences.avoid)
    }
}
