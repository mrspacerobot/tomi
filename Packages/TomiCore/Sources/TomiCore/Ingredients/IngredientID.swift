/// The stable id of an ingredient, such as `olive-oil`.
/// Ids come from the ingredient table and are permanent: never rename or reuse one, because preferences keep it.
public struct IngredientID: RawRepresentable, Hashable, Comparable, Codable, Sendable, ExpressibleByStringLiteral {
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
