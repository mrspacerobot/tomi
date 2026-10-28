/// One level of a skill: the cooks counted, how many complete it, and whether it is open, granted or complete.
public struct SnapshotLevel: Hashable, Decodable, Sendable {
    public let number: Int
    public let cooks: Int
    public let cooksToComplete: Int
    public let open: Bool
    /// Given by the cook's experience answer, with no XP.
    public let granted: Bool
    public let complete: Bool
}
