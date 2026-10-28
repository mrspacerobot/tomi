/// What a cook log entry cooked, and the skill and level it taught.
/// The skill and level are recorded beside the id, so progress never needs the lesson library, and a lesson the
/// library no longer has, or does not have yet, still counts where it was taught.
public struct CookedLesson: Hashable, Sendable {
    /// The id of a bundled lesson or, when there is a graph version, of the graph recipe.
    public let id: LessonID
    public let skill: SkillID
    /// The level of the skill the lesson taught, counting from 1.
    public let level: Int
    /// The graph version a recipe was cooked at. Only a graph recipe has one, and only a graph recipe can be sent:
    /// the server takes no cook of a bundled lesson.
    public let graphVersion: String?

    public init(id: LessonID, skill: SkillID, level: Int, graphVersion: String? = nil) {
        self.id = id
        self.skill = skill
        self.level = level
        self.graphVersion = graphVersion
    }
}
