/// One technique on the menu, such as searing or a roux.
public struct Skill: Identifiable, Hashable, Codable, Sendable {
    public let id: SkillID
    public let course: CourseID
    public let name: LocalizedText
    /// One line under the name on the menu.
    public let summary: LocalizedText
    /// Techniques that must be learned before this one is served. Always earlier on the menu.
    public let prerequisites: [SkillID]
    public let levels: [SkillLevel]
}
