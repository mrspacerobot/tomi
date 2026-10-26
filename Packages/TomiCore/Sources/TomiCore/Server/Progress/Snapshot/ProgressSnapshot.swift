/// The cook's progress as `GET /v1/progress` and `POST /v1/cook-entries` send it.
/// The server computes every number here from its cook log. The app shows them as they are and works out none.
public struct ProgressSnapshot: Hashable, Decodable, Sendable {
    /// Declared first, so a snapshot of an unknown layout is refused before anything else in it is read.
    public let schemaVersion: ProgressSchemaVersion
    public let rulesVersion: Int
    public let catalogVersion: Int
    public let computedAt: ServerInstant
    public let calendar: CalendarContext
    public let xp: Int
    public let rank: SnapshotRank
    public let streak: SnapshotStreak
    /// In catalog order, keyed by the skill ids `GET /v1/options` sends.
    public let skills: [SnapshotSkill]
    public let masteredCount: Int
    public let focusSkill: SkillID?
    public let counted: SnapshotCounts
}
