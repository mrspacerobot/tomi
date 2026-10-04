/// The stable id of a cuisine, such as `italian`.
/// Ids come from the library data and are permanent: never rename or reuse one, because preferences keep it forever.
public struct CuisineID: RawRepresentable, Hashable, Comparable, Codable, Sendable, ExpressibleByStringLiteral {
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
