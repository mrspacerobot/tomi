/// One canonical ingredient and the facts that decide who may eat it.
/// It is content, not code: it ships in the ingredient table of the lesson library.
public struct Ingredient: Identifiable, Hashable, Codable, Sendable {
    public let id: IngredientID
    public let name: LocalizedText
    /// Every declared fact this ingredient is or holds. Empty says: none of them.
    /// The file must always write the list, so a forgotten one is an error and never a plain plant.
    public let facts: Set<IngredientFactID>

    public init(id: IngredientID, name: LocalizedText, facts: Set<IngredientFactID>) {
        self.id = id
        self.name = name
        self.facts = facts
    }

    /// Reads strictly: every field is required, and a field with another name is an error.
    public init(from decoder: any Decoder) throws {
        try decoder.rejectFields(notIn: CodingKeys.self)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(IngredientID.self, forKey: .id)
        name = try container.decode(LocalizedText.self, forKey: .name)
        facts = try container.decode(Set<IngredientFactID>.self, forKey: .facts)
    }

    /// The names of the fields in the file. Every one is required.
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case facts = "contains"
    }
}
