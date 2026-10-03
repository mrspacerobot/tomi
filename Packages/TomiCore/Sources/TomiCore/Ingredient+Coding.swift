/// Reads one ingredient strictly: nothing that is written may be skipped, because a skipped fact looks like a safe one.
extension Ingredient {
    public init(from decoder: any Decoder) throws {
        try Ingredient.rejectUnknownFields(in: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(IngredientID.self, forKey: .id)
        name = try container.decode(LocalizedText.self, forKey: .name)
        let written = try container.decode([String].self, forKey: .facts)
        facts = Ingredient.knownFacts(in: written)
        unknownFacts = Ingredient.unknownFacts(in: written)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(facts.map(\.rawValue).sorted() + unknownFacts, forKey: .facts)
    }

    /// A field with another name, such as `allergens` or a misspelt `contain`, would otherwise be ignored
    /// and its facts lost without a word.
    private static func rejectUnknownFields(in decoder: any Decoder) throws {
        let fields = try decoder.container(keyedBy: FieldName.self)
        for field in fields.allKeys where CodingKeys(stringValue: field.stringValue) == nil {
            throw DecodingError.dataCorruptedError(
                forKey: field,
                in: fields,
                debugDescription: "An ingredient has no field with this name."
            )
        }
    }

    private static func knownFacts(in written: [String]) -> Set<IngredientFact> {
        var known: Set<IngredientFact> = []
        for value in written {
            if let fact = IngredientFact(rawValue: value) {
                known.insert(fact)
            }
        }
        return known
    }

    private static func unknownFacts(in written: [String]) -> [String] {
        written.filter { IngredientFact(rawValue: $0) == nil }
    }
}
