/// A server-named course, with a count of mastered techniques when the snapshot names every one of them.
public struct HomeCourseProgress: Equatable, Identifiable, Sendable {
    public let id: CourseID
    public let title: String
    public let masteredCount: Int?
    public let skillCount: Int
    public let skills: [HomeSkillProgress]

    init(option: OptionCourse, skills: [HomeSkillProgress]) {
        id = option.id
        title = option.title
        skillCount = skills.count
        self.skills = skills
        masteredCount = Self.mastered(skills)
    }

    private static func mastered(_ skills: [HomeSkillProgress]) -> Int? {
        guard !skills.isEmpty, skills.allSatisfy({ $0.progress != nil }) else { return nil }
        return skills.count(where: { $0.progress?.status == .mastered })
    }
}
