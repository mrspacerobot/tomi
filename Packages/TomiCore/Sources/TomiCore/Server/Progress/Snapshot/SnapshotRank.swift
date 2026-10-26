/// The cook's rank, with the XP it starts at and the XP of the next one, so the bar is drawn from given numbers.
public struct SnapshotRank: Hashable, Decodable, Sendable {
    /// Permanent. The name follows the cook's language.
    public let id: String
    public let name: String
    public let tier: Int
    public let startsAt: Int
    public let nextAt: Int
}
