/// What `POST /v1/specials` sends back: tonight's special and up to two alternatives.
public struct SpecialsResponse: Hashable, Codable, Sendable {
    public var libraryVersion = 0
    /// How the offers were ordered, or nil when a newer server names a way this build does not know.
    public var rankedBy: RankedBy?
    public var special: Offer?
    public var alternatives: [Offer] = []

    public init() {}

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        libraryVersion = try container.decode(Int.self, forKey: .libraryVersion)
        rankedBy = container.knownValue(RankedBy.self, forKey: .rankedBy)
        special = try container.decodeIfPresent(Offer.self, forKey: .special)
        alternatives = try container.decode([Offer].self, forKey: .alternatives)
    }

    enum CodingKeys: String, CodingKey {
        case libraryVersion, rankedBy, special, alternatives
    }
}
