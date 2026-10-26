/// One skill of the catalog as the server judged it for the cook.
public struct SnapshotSkill: Hashable, Decodable, Sendable {
    public let skill: SkillID
    public let status: SnapshotSkillStatus
    public let missingPrerequisites: [SkillID]
    public let currentLevel: Int
    public let levels: [SnapshotLevel]
}
