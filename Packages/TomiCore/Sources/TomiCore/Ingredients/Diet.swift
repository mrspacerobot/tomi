/// A diet a cook can keep, such as vegetarian, and the ingredient facts it rules out.
/// It is content, not code: the list ships in the ingredient table. A cook with no diet eats everything.
public struct Diet: Identifiable, Hashable, Codable, Sendable {
    public let id: DietID
    public let name: LocalizedText
    /// One line under the name on the diet screen, such as "No meat or fish".
    public let summary: LocalizedText
    /// An ingredient with any of these facts is not served to a cook on this diet. Never empty.
    public let excludes: Set<IngredientFactID>

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case summary
        case excludes
    }
}
