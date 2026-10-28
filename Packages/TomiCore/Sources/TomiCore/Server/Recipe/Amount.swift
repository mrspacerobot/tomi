/// How much of an ingredient a lesson uses: a number and a unit from the closed list, never free text.
public struct Amount: Hashable, Codable, Sendable {
    public var value: Double
    public var unit: AmountUnit

    public init(_ value: Double, _ unit: AmountUnit) {
        self.value = value
        self.unit = unit
    }

    /// More than nothing, and a real number. A file can not write infinity, but code can make one.
    public var isPositive: Bool {
        value.isFinite && value > 0
    }
}
