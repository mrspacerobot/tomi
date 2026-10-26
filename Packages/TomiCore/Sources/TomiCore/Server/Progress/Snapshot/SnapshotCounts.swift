/// What the server counted from the cook log for this snapshot.
public struct SnapshotCounts: Hashable, Decodable, Sendable {
    public let finishedCooks: Int
    /// Cooks of a skill or level the catalog does not know yet: they earn XP and count for the streak only.
    public let ignoredUnknownSkillOrLevel: Int

    public init(finishedCooks: Int, ignoredUnknownSkillOrLevel: Int) {
        self.finishedCooks = finishedCooks
        self.ignoredUnknownSkillOrLevel = ignoredUnknownSkillOrLevel
    }
}
