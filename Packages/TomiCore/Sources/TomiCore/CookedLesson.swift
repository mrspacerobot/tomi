/// What a cook log entry cooked: the lesson, and the skill and level it taught.
/// The skill and level are recorded beside the lesson id, so progress never needs the lesson library,
/// and a lesson the library no longer has, or does not have yet, still counts where it was taught.
public struct CookedLesson: Hashable, Sendable {
    public let id: LessonID
    public let skill: SkillID
    /// The level of the skill the lesson taught, counting from 1.
    public let level: Int

    public init(id: LessonID, skill: SkillID, level: Int) {
        self.id = id
        self.skill = skill
        self.level = level
    }
}
