/// A swap of the lesson that the cook, or Tomi for them, chose tonight: which ingredient went out and which came in.
/// It only points at a swap the lesson lists. The amounts stay in the library, so they are read fresh on resume.
public struct AppliedSwap: Hashable, Sendable {
    public let removed: IngredientID
    public let added: IngredientID

    public init(removed: IngredientID, added: IngredientID) {
        self.removed = removed
        self.added = added
    }
}
