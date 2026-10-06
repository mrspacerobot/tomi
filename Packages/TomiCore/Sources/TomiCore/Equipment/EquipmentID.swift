/// The stable id of something in a kitchen that a lesson may need, such as `oven`.
/// The equipment, its names and what a kitchen is assumed to have come from the equipment list of the library
/// (`EquipmentList`), so no Swift file names one. A lesson is offered only when the kitchen has everything it names.
/// Ids are permanent: never rename or reuse one, because preferences keep it forever.
public struct EquipmentID: RawRepresentable, Hashable, Comparable, Codable, Sendable, ExpressibleByStringLiteral {
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
