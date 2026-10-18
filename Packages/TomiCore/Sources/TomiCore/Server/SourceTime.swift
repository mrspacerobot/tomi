/// How long a source step takes: one length, or a range from the shortest to the longest.
public struct SourceTime: Hashable, Decodable, Sendable {
    public let shortest: Double
    public let longest: Double
    public let unit: String

    public init(shortest: Double, longest: Double, unit: String) {
        self.shortest = shortest
        self.longest = longest
        self.unit = unit
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        unit = try container.decode(String.self, forKey: .unit)
        if let value = try container.decodeIfPresent(Double.self, forKey: .value) {
            shortest = value
            longest = value
        } else {
            shortest = try container.decode(Double.self, forKey: .from)
            longest = try container.decode(Double.self, forKey: .to)
        }
    }

    enum CodingKeys: String, CodingKey {
        case value, from, to, unit
    }
}
