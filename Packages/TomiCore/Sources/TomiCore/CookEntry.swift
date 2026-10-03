import Foundation

/// One line of the cook log: a lesson the cook started, and how it went.
/// The log is the source of truth. Progress, streak and XP are computed from its entries, never stored beside them.
/// Entries are written once and never changed, so two devices can merge their logs by id.
public struct CookEntry: Identifiable, Hashable, Sendable {
    /// Made once when the cook is logged. The same id on two devices is the same cook.
    public let id: UUID
    public let lesson: LessonID
    public let skill: SkillID
    /// The level of the skill the lesson taught, counting from 1.
    public let level: Int
    public let date: Date
    /// The cook left before the last step. Such an entry is kept, but it never counts as a cook.
    public let stoppedEarly: Bool
    public let quizCorrect: Bool
    /// The cook's weekly goal when this was cooked, so a later change of goal never rejudges a past week.
    public let weeklyGoal: Int

    public init(
        id: UUID,
        lesson: LessonID,
        skill: SkillID,
        level: Int,
        date: Date,
        stoppedEarly: Bool,
        quizCorrect: Bool,
        weeklyGoal: Int
    ) {
        self.id = id
        self.lesson = lesson
        self.skill = skill
        self.level = level
        self.date = date
        self.stoppedEarly = stoppedEarly
        self.quizCorrect = quizCorrect
        self.weeklyGoal = weeklyGoal
    }
}
