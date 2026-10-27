/// A server-named technique with local status only when its learning graph matches.
public struct HomeSkillProgress: Equatable, Identifiable, Sendable {
    public let id: SkillID
    public let name: String
    public let summary: String
    public let progress: SkillProgress?
    public let missingPrerequisiteNames: [String]?

    init(option: OptionSkill, progress: SkillProgress?, missingPrerequisiteNames: [String]?) {
        id = option.id
        name = option.name
        summary = option.summary
        self.progress = progress
        self.missingPrerequisiteNames = missingPrerequisiteNames
    }
}
