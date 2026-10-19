/// One step of the graph's own instructions, as the graph wrote it.
public struct SourceStep: Hashable, Decodable, Sendable {
    public let text: String
    /// How long the step takes, or nil when it has no time or a time this build cannot read.
    public let time: SourceTime?

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        text = try container.decode(String.self, forKey: .text)
        time = try container.decodeIfPresent(SourceTime.self, forKey: .time)
    }

    enum CodingKeys: String, CodingKey {
        case text, time
    }
}
