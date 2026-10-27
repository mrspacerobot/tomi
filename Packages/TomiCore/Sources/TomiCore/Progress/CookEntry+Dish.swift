extension CookEntry {
    /// The graph recipe this cook made, or nil for a cook of a bundled lesson.
    var dish: CookedDish? {
        guard let graphVersion = lesson.graphVersion else {
            return nil
        }
        return CookedDish(recipe: RecipeID(rawValue: lesson.id.rawValue), graphVersion: graphVersion)
    }

    /// Whether the server could take this cook. A cook that cannot be sent stays on the phone and is never counted
    /// as waiting, because it never will be.
    public var isSendable: Bool {
        dish != nil
    }
}
