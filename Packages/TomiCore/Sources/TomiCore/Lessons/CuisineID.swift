/// The stable id of the cuisine a lesson belongs to, such as `italian`.
/// The list of cuisines lives on Tomi's server. Ids are permanent: never rename or reuse one.
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
