/// The server's id of one fridge scan. Sent back with the confirmed ingredients, so a kept photo can be
/// labelled with what the cook said was really there.
public struct ScanID: RawRepresentable, Hashable, Codable, Sendable, ExpressibleByStringLiteral {
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    public init(stringLiteral value: String) {
        self.init(rawValue: value)
    }
}
