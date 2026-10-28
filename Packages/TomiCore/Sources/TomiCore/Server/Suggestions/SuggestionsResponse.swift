/// What `POST /v1/lessons/suggest` sends back: tonight's special and up to two alternatives, from the graph.
/// A suggestion that cannot be read is left out, so it is unavailable and never shown on trust.
public struct SuggestionsResponse: Hashable, Decodable, Sendable {
    /// How the suggestions were ordered, or nil when a newer server names a way this build does not know.
    public var rankedBy: RankedBy?
    /// The version of the cooking graph the answer was made from, or nil when the server named none.
    public var graphVersion: String?
    public var special: Suggestion?
    public var alternatives: [Suggestion] = []

    public init() {}

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        rankedBy = container.knownValue(RankedBy.self, forKey: .rankedBy)
        graphVersion = try? container.decodeIfPresent(String.self, forKey: .graphVersion)
        let suggestions = try Self.readSuggestions(container)
        special = suggestions.special?.from(graphVersion: graphVersion)
        alternatives = suggestions.alternatives.map { $0.from(graphVersion: graphVersion) }
    }

    enum CodingKeys: String, CodingKey {
        case graphVersion, rankedBy, special, alternatives
    }
}
