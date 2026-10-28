/// A permanent reason the server gave for rejecting a cook entry, such as `cooked_in_future`.
/// The server owns the list. The app keeps and logs the code and decides nothing by it.
public struct CookEntryProblem: RawRepresentable, Hashable, Codable, Sendable, ExpressibleByStringLiteral {
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    public init(stringLiteral value: String) {
        self.init(rawValue: value)
    }
}
