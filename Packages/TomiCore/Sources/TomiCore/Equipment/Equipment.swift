/// One thing in a kitchen that a lesson may need, such as an oven.
/// It is content, not code: it ships in the equipment list of the lesson library.
public struct Equipment: Identifiable, Hashable, Codable, Sendable {
    public let id: EquipmentID
    public let name: LocalizedText
    /// One line beside the name on the kitchen screen, saying what it is used for.
    public let summary: LocalizedText
    /// Whether a kitchen is taken to have it until the cook answers the kitchen question.
    /// The file must always say so, because a forgotten answer would quietly hide or offer dishes.
    public let isAssumed: Bool

    public init(id: EquipmentID, name: LocalizedText, summary: LocalizedText, isAssumed: Bool) {
        self.id = id
        self.name = name
        self.summary = summary
        self.isAssumed = isAssumed
    }

    /// Reads strictly: every field is required, and a field with another name is an error.
    public init(from decoder: any Decoder) throws {
        try decoder.rejectFields(notIn: CodingKeys.self)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(EquipmentID.self, forKey: .id)
        name = try container.decode(LocalizedText.self, forKey: .name)
        summary = try container.decode(LocalizedText.self, forKey: .summary)
        isAssumed = try container.decode(Bool.self, forKey: .isAssumed)
    }

    /// The names of the fields in the file. Every one is required.
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case summary
        case isAssumed = "assumed"
    }
}
