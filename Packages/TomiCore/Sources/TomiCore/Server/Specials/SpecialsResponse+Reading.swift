extension SpecialsResponse {
    /// The special and the alternatives that could be read. When the server sent suggestions and none could be read,
    /// that is an error: it must not look like a night with nothing to cook.
    static func readSuggestions(
        _ container: KeyedDecodingContainer<CodingKeys>
    ) throws -> (special: Suggestion?, alternatives: [Suggestion]) {
        let sentSpecial = try container.decodeIfPresent(LossySuggestion.self, forKey: .special)
        let sentAlternatives = try container.decode([LossySuggestion].self, forKey: .alternatives)
        let sent = (sentSpecial.map { [$0] } ?? []) + sentAlternatives
        let readable = sent.compactMap(\.suggestion)
        if !sent.isEmpty && readable.isEmpty {
            let context = DecodingError.Context(codingPath: container.codingPath, debugDescription: "No suggestion.")
            throw DecodingError.dataCorrupted(context)
        }
        return (sentSpecial?.suggestion, sentAlternatives.compactMap(\.suggestion))
    }
}

/// A suggestion that may fail to read without failing the answer around it.
struct LossySuggestion: Decodable {
    let suggestion: Suggestion?

    init(from decoder: any Decoder) throws {
        suggestion = try? Suggestion(from: decoder)
    }
}
