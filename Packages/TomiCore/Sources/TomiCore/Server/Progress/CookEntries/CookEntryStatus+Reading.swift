/// Reading a status from the server's word for it. A word this app does not know is kept as it came.
extension CookEntryStatus: Decodable {
    public init(from decoder: any Decoder) throws {
        let word = try decoder.singleValueContainer().decode(String.self)
        guard let known = KnownCookEntryStatus(rawValue: word) else {
            self = .unknown(word)
            return
        }
        self = known.status
    }

    /// Whether the entry stays in the outbox as it is, to be sent again later.
    public var keepsTheEntry: Bool {
        switch self {
        case .accepted, .duplicate, .conflict, .rejected:
            false
        case .unknown:
            true
        }
    }
}
