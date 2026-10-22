extension Suggestion {
    /// The parts of the original recipe the safe plan leaves out, named as the original recipe names the ingredient
    /// of that part. A part no line names falls back to the part's id made readable.
    public var omittedNames: [String] {
        safePlan.omittedParts.map(omittedName)
    }

    private func omittedName(_ part: String) -> String {
        let line = originalRecipe.ingredients.first { $0.part == part }
        guard let line else {
            return OptionID(rawValue: part).readable
        }
        return name(ofSourceIngredient: line.thing)
    }
}
