/// One way a skill catalog can be wrong. The validator lists them all so a library build can report every problem.
public enum CatalogIssue: Hashable, Sendable {
    /// An empty menu would leave the cook with nothing to learn.
    case noCourses
    /// A blank id is found by where it sits in its list, counting from 0, since it has no name to report.
    case blankCourseID(position: Int)
    case blankSkillID(position: Int)
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
