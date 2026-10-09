/// The stable id of something in a kitchen that a lesson may need, such as `oven`.
/// The equipment list and the check that a kitchen has what a lesson needs live on Tomi's server,
/// so no Swift file names one. Ids are permanent: never rename or reuse one.
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
