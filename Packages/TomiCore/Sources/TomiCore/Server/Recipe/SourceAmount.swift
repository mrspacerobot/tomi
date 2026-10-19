/// A number and the unit the graph counts it in, such as 30 gram or 2 serving. The unit stays as written.
public struct SourceAmount: Hashable, Decodable, Sendable {
    public let value: Double
    public let unit: String

    public init(value: Double, unit: String) {
        self.value = value
        self.unit = unit
    }
}
