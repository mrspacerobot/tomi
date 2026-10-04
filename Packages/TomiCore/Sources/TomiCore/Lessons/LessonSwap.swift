/// A reviewed substitution: one ingredient of the lesson replaced by another ingredient of the table.
/// A swap removes an avoid item or changes the diet, such as butter to olive oil, which removes dairy.
/// What it changes is never written here: it is worked out again from the table after the swap is applied.
public struct LessonSwap: Hashable, Codable, Sendable {
    /// The ingredient of the lesson that is taken out.
    public var ingredient: IngredientID
    /// What goes in instead, with its own amounts, since a swap is rarely gram for gram.
    public var replacement: LessonIngredient

    /// The names of the fields in the file.
    enum CodingKeys: String, CodingKey {
        case ingredient = "replace"
        case replacement = "with"
    }
}
