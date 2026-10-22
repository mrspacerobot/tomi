/// The id of a recipe in the cooking graph, such as `recipe/soft-scrambled-eggs`.
/// The graph owns these ids. The app shows what it is sent and names none of them in code.
public struct RecipeID: RawRepresentable, Hashable, Codable, Sendable, ExpressibleByStringLiteral {
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    public init(stringLiteral value: String) {
        self.init(rawValue: value)
    }
}
