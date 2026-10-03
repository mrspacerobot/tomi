/// One way a skill catalog can be wrong. The validator lists them all so a library build can report every problem.
public enum CatalogIssue: Hashable, Sendable {
    case duplicateCourse(CourseID)
    case duplicateSkill(SkillID)
    case unknownCourse(SkillID, CourseID)
    case emptyCourse(CourseID)
    case skillOutOfCourseOrder(SkillID)
    case unknownPrerequisite(SkillID, SkillID)
    case prerequisiteNotEarlier(SkillID, SkillID)
    case noLevels(SkillID)
    case levelsOutOfOrder(SkillID)
    case missingCourseTitle(CourseID)
    /// The skill's name, summary or one of its level names has no English text.
    case missingSkillText(SkillID)
}
