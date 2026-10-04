/// The stable id of one thing an ingredient is or holds that decides who may eat it, such as `dairy` or `gluten`.
/// The ingredient table declares the list of facts. Ingredients, avoid items and diets may only use declared ones,
/// so no Swift file names a fact. Ids are permanent: never rename or reuse one.
public struct IngredientFactID: RawRepresentable, Hashable, Comparable, Codable, Sendable, ExpressibleByStringLiteral {
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    public init(stringLiteral value: String) {
        self.init(rawValue: value)
    }

    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}
