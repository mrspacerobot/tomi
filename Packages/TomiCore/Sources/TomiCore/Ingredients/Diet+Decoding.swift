extension Diet {
    /// Reads strictly: every field is required, and a field with another name is an error.
    public init(from decoder: any Decoder) throws {
        try decoder.rejectFields(notIn: CodingKeys.self)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(DietID.self, forKey: .id)
        name = try container.decode(LocalizedText.self, forKey: .name)
        summary = try container.decode(LocalizedText.self, forKey: .summary)
        excludes = try container.decode(Set<IngredientFactID>.self, forKey: .excludes)
    }
}
