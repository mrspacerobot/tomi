/// The diet and avoid list the server checked an offer against, after its swaps.
public struct CheckedRestrictions: Hashable, Codable, Sendable {
    public let diet: OptionID?
    public let avoid: Set<OptionID>

    public init(diet: OptionID?, avoid: Set<OptionID>) {
        self.diet = diet
        self.avoid = avoid
    }

    /// Both fields must be there: a missing diet is not "eats everything".
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        guard container.contains(.diet) else {
            let context = DecodingError.Context(codingPath: container.codingPath, debugDescription: "No diet.")
            throw DecodingError.keyNotFound(CodingKeys.diet, context)
        }
        diet = try container.decodeIfPresent(OptionID.self, forKey: .diet)
        avoid = try container.decode(Set<OptionID>.self, forKey: .avoid)
    }

    /// A cook who eats everything is written as a null diet, never left out.
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(diet, forKey: .diet)
        try container.encode(avoid.sorted(), forKey: .avoid)
    }

    enum CodingKeys: String, CodingKey {
        case diet
        case avoid
    }
}
