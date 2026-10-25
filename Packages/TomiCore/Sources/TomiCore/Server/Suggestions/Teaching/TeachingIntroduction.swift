/// Graph-authored introduction prose and its content tier.
public struct TeachingIntroduction: Hashable, Decodable, Sendable {
    public let concept: String
    public let what: String
    public let why: String
    public let tier: TeachingTier

    enum CodingKeys: String, CodingKey { case concept, what, why, tier }

    public init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        concept = try values.decode(String.self, forKey: .concept)
        what = try values.decode(String.self, forKey: .what)
        why = try values.decode(String.self, forKey: .why)
        tier = try values.decode(TeachingTier.self, forKey: .tier)
        try validate(in: values)
    }

    private func validate(in values: KeyedDecodingContainer<CodingKeys>) throws {
        let prose = [concept, what, why]
        guard prose.allSatisfy({ !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }) else {
            throw DecodingError.dataCorruptedError(
                forKey: .concept,
                in: values,
                debugDescription: "Invalid introduction."
            )
        }
    }
}
