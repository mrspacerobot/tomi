/// The stable id of an ingredient a lesson uses, such as `olive-oil`.
/// The ingredient table, with every fact about who may eat what, lives on Tomi's server. Ids are permanent:
/// never rename or reuse one, because lesson bookmarks keep it.
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
