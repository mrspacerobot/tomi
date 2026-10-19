/// What `POST /v1/lessons/suggest` sends back: tonight's special and up to two alternatives, from the graph.
/// An offer that cannot be read is left out, so it is unavailable and never shown on trust.
public struct SpecialsResponse: Hashable, Decodable, Sendable {
    public var graphVersion = ""
    public var graphChannel = ""
    /// How the offers were ordered, or nil when a newer server names a way this build does not know.
    public var rankedBy: RankedBy?
    public var special: Offer?
    public var alternatives: [Offer] = []

    public init() {}

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        graphVersion = try container.decode(String.self, forKey: .graphVersion)
        graphChannel = try container.decode(String.self, forKey: .graphChannel)
        rankedBy = container.knownValue(RankedBy.self, forKey: .rankedBy)
        let offers = try Self.readOffers(container)
        special = offers.special
        alternatives = offers.alternatives
    }

    enum CodingKeys: String, CodingKey {
        case graphVersion, graphChannel, rankedBy, special, alternatives
    }
}
