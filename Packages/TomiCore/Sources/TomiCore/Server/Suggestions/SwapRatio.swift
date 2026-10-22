/// How much of a stand-in replaces how much of the original, counted by weight, volume or number.
public struct SwapRatio: Hashable, Decodable, Sendable {
    public let standIn: Double
    public let original: Double
    /// What the two are counted in, as the graph writes it, such as `volume`.
    public let by: String

    public init(standIn: Double, original: Double, by: String) {
        self.standIn = standIn
        self.original = original
        self.by = by
    }

    enum CodingKeys: String, CodingKey {
        case standIn = "stand_in"
        case original, by
    }
}
