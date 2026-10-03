/// How far the cook is with one level of a skill.
public struct LevelProgress: Hashable, Sendable {
    /// The level's number in the catalog, counting from 1.
    public let number: Int
    /// Finished cooks at this level.
    public let cooks: Int
    /// Lessons of this level may be offered: the skill is served and every level before this one is complete.
    public let isOpen: Bool

    public var isComplete: Bool {
        GameRules.isLevelComplete(cooks: cooks)
    }
}
