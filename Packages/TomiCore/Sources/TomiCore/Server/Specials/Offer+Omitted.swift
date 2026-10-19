extension Offer {
    /// The parts of the source recipe the safe plan leaves out, named as the source recipe names the ingredient
    /// of that part. A part no line names falls back to the part's id made readable.
    public var omittedNames: [String] {
        safePlan.omittedParts.map(omittedName)
    }

    private func omittedName(_ part: String) -> String {
        let line = sourceRecipe.ingredients.first { $0.part == part }
        guard let line else {
            return OptionID(rawValue: part).readable
        }
        return name(ofSourceIngredient: line.thing)
    }
}
