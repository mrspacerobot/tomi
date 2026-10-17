/// A swap the server applied to an offer: one ingredient of the lesson out, another in.
/// It is always one the lesson lists, so the player can apply it to the lesson file.
public struct OfferSwap: Hashable, Codable, Sendable {
    public let removed: NamedOption
    public let added: NamedOption

    public init(removed: NamedOption, added: NamedOption) {
        self.removed = removed
        self.added = added
    }

    /// The swap as the bookmark of the lesson in progress keeps it.
    public var applied: AppliedSwap {
        let out = IngredientID(rawValue: removed.id.rawValue)
        let into = IngredientID(rawValue: added.id.rawValue)
        return AppliedSwap(removed: out, added: into)
    }
}
