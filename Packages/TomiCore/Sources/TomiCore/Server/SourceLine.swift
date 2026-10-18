/// One ingredient line of the graph's own recipe: the graph's ingredient, its part of the dish and its amount.
public struct SourceLine: Hashable, Decodable, Sendable {
    public let thing: OptionID
    public let part: String
    /// How much, or nil when the line has no amount this build can read.
    public let amount: SourceAmount?

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        thing = try container.decode(OptionID.self, forKey: .thing)
        part = try container.decode(String.self, forKey: .part)
        amount = try? container.decodeIfPresent(SourceAmount.self, forKey: .amount)
    }

    enum CodingKeys: String, CodingKey {
        case thing, part, amount
    }
}
