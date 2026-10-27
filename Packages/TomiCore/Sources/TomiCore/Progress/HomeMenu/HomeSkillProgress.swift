/// A server-named technique with the server's progress for it, when the snapshot names it.
public struct HomeSkillProgress: Equatable, Identifiable, Sendable {
    public let id: SkillID
    public let name: String
    public let summary: String
    public let progress: SnapshotSkill?
    /// The menu's names of the prerequisites still missing. Nil when one of them is not on the menu.
    public let missingPrerequisiteNames: [String]?

    init(option: OptionSkill, progress: SnapshotSkill?, missingPrerequisiteNames: [String]?) {
        id = option.id
        name = option.name
        summary = option.summary
        self.progress = progress
        self.missingPrerequisiteNames = missingPrerequisiteNames
    }
}
