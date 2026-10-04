/// One canonical ingredient and the facts that decide who may eat it.
/// It is content, not code: it ships in the ingredient table of the lesson library.
public struct Ingredient: Identifiable, Hashable, Codable, Sendable {
    public let id: IngredientID
    public let name: LocalizedText
    /// Everything on the closed fact list that this ingredient is or holds. Empty says: none of them.
    /// The file must always write the list, so a forgotten one is an error and never a plain plant.
    public let facts: Set<IngredientFact>
    /// Values written in the file's `contains` list that are not on the closed fact list, in file order.
    /// Validation rejects a table that has any, and until then the ingredient suits nobody.
    public let unknownFacts: [String]

    public init(id: IngredientID, name: LocalizedText, facts: Set<IngredientFact>) {
        self.id = id
        self.name = name
        self.facts = facts
        self.unknownFacts = []
    }

    /// The names of the fields in the file. Every one is required.
    enum CodingKeys: String, CodingKey, CaseIterable {
        case id
        case name
        case facts = "contains"
    }
}
