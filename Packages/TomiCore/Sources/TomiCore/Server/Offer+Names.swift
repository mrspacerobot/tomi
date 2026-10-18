extension Offer {
    /// The name of an ingredient of the source recipe, in the cook's language.
    /// The server names the ingredients of the safe plan and the ones it swapped out. Anything else, such as
    /// an omitted part, falls back to the graph's id made readable (`OptionID.readable`).
    public func name(ofSourceIngredient thing: OptionID) -> String {
        if let planned = safePlan.ingredients.first(where: { $0.id == thing }) {
            return planned.name
        }
        if let swapped = safePlan.substitutions.first(where: { $0.removed.id == thing }) {
            return swapped.removed.name
        }
        return thing.readable
    }

    /// Whether the safe plan leaves this line of the source recipe out.
    public func omits(_ line: SourceLine) -> Bool {
        safePlan.omittedParts.contains(line.part)
    }

    /// The substitution that replaces this line of the source recipe, if the safe plan makes one.
    public func substitution(for line: SourceLine) -> OfferSwap? {
        safePlan.substitutions.first { $0.removed.id == line.thing }
    }
}
