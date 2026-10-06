/// Every piece of equipment a lesson may ask for, and what a kitchen is assumed to have.
/// It is content, not code: it ships in the lesson library and is read with `decode(from:)`.
/// Equipment that is not listed is unknown: a lesson that names it is rejected, never shown.
public struct EquipmentList: Hashable, Codable, Sendable {
    /// The list layout this build understands. Bump it, and the validator, when the layout changes.
    public static let supportedSchemaVersion = 1

    public let schemaVersion: Int
    /// In the order the kitchen screen shows them.
    public let equipment: [Equipment]

    public init(schemaVersion: Int, equipment: [Equipment]) {
        self.schemaVersion = schemaVersion
        self.equipment = equipment
    }

    /// Reads strictly: a field with another name is an error, so a misspelt one is never ignored.
    public init(from decoder: any Decoder) throws {
        try decoder.rejectFields(notIn: CodingKeys.self)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        schemaVersion = try container.decode(Int.self, forKey: .schemaVersion)
        equipment = try container.decode([Equipment].self, forKey: .equipment)
    }

    /// Whether the list names this piece of equipment.
    public func contains(_ id: EquipmentID) -> Bool {
        equipment.contains { $0.id == id }
    }

    /// What a kitchen is taken to have until the cook answers the kitchen question.
    public var standardKitchen: Set<EquipmentID> {
        let assumed = equipment.filter(\.isAssumed)
        return Set(assumed.map(\.id))
    }

    /// The names of the fields in the file. Every one is required.
    enum CodingKeys: String, CodingKey {
        case schemaVersion
        case equipment
    }
}
