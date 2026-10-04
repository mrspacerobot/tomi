/// Something a cook can say they do not eat, such as nuts, and the ingredient facts that trigger it.
/// It is content, not code: the list ships in the ingredient table, next to the ingredients it judges.
public struct AvoidItem: Identifiable, Hashable, Codable, Sendable {
    public let id: AvoidItemID
    public let name: LocalizedText
    /// An ingredient with any of these facts is not served to a cook who avoids this item. Never empty.
    public let triggeredBy: Set<IngredientFactID>

    public init(id: AvoidItemID, name: LocalizedText, triggeredBy: Set<IngredientFactID>) {
        self.id = id
        self.name = name
        self.triggeredBy = triggeredBy
    }

    /// Reads strictly: every field is required, and a field with another name is an error.
    public init(from decoder: any Decoder) throws {
        try decoder.rejectFields(notIn: CodingKeys.self)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(AvoidItemID.self, forKey: .id)
        name = try container.decode(LocalizedText.self, forKey: .name)
        triggeredBy = try container.decode(Set<IngredientFactID>.self, forKey: .triggeredBy)
    }

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case triggeredBy
    }
}
