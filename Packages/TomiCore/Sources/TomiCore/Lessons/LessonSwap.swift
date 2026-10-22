/// A reviewed substitution: one ingredient of the lesson replaced by another, such as butter by olive oil.
/// What it changes for a diet is never written here: Tomi's server works it out and checks every suggestion.
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
