/// The stable id of anything the cook picks from a list the server sends: a diet, an avoid item, a cuisine,
/// a piece of equipment or an ingredient, such as `vegetarian` or `olive-oil`.
/// The lists, their names and every rule about them belong to Tomi's server. The app shows what it is sent,
/// sends back the ids the cook picked, and names none of them in code.
public struct OptionID: RawRepresentable, Hashable, Comparable, Codable, Sendable, ExpressibleByStringLiteral {
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
