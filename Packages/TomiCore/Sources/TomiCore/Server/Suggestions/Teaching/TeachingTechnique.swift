/// Graph-selected technique label and content tier.
public struct TeachingTechnique: Hashable, Decodable, Sendable {
    public let id: String
    public let name: String
    public let tier: TeachingTier

    enum CodingKeys: String, CodingKey { case id, name, tier }

    public init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(String.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
        tier = try values.decode(TeachingTier.self, forKey: .tier)
        try validate(in: values)
    }

    private func validate(in values: KeyedDecodingContainer<CodingKeys>) throws {
        guard isValidTechniqueID(id), !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw DecodingError.dataCorruptedError(forKey: .id, in: values, debugDescription: "Invalid technique.")
        }
    }
}

private func isValidTechniqueID(_ id: String) -> Bool {
    let pieces = id.split(separator: "/", omittingEmptySubsequences: false)
    guard pieces.count == 2, pieces[0] == "technique", let slug = pieces.last else { return false }
    return isValidTeachingSlug(slug)
}
