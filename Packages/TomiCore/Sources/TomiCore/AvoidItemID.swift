/// The stable id of something the cook does not eat, whether for an allergy, a belief or taste, such as `nuts`.
/// The list of avoid items and their names comes from the ingredient table data, which tags every ingredient
/// with these ids, so no Swift file names one. An id the table does not know, for example one saved by a newer app,
/// is kept, never dropped: the filter must then treat every dish as unavailable rather than ignore it.
/// Ids are permanent: never rename or reuse one, because preferences keep it forever.
public struct AvoidItemID: RawRepresentable, Hashable, Comparable, Codable, Sendable, ExpressibleByStringLiteral {
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
