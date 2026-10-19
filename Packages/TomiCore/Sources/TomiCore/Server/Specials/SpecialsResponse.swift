/// What `POST /v1/lessons/suggest` sends back: tonight's special and up to two alternatives, from the graph.
/// A suggestion that cannot be read is left out, so it is unavailable and never shown on trust.
public struct SpecialsResponse: Hashable, Decodable, Sendable {
    /// How the suggestions were ordered, or nil when a newer server names a way this build does not know.
    public var rankedBy: RankedBy?
    public var special: Suggestion?
    public var alternatives: [Suggestion] = []

    public init() {}

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        rankedBy = container.knownValue(RankedBy.self, forKey: .rankedBy)
        let suggestions = try Self.readSuggestions(container)
        special = suggestions.special
        alternatives = suggestions.alternatives
    }

    enum CodingKeys: String, CodingKey {
        case rankedBy, special, alternatives
    }
}
