/// The stable id of a diet the cook keeps, such as `vegetarian`.
/// The list of diets and their names comes from the ingredient table data, which says for every ingredient which
/// diets it suits, so no Swift file names one. A diet id the table does not know, for example one saved by a newer
/// app, is kept, never dropped: the filter must then treat every dish as unavailable rather than ignore it.
/// Ids are permanent: never rename or reuse one, because preferences keep it forever.
public struct DietID: RawRepresentable, Hashable, Comparable, Codable, Sendable, ExpressibleByStringLiteral,
    SavedFoodRestriction
{
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
