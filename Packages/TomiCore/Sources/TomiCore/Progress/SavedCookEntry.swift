import Foundation

/// One line of the cook log as it lies in the store: one value per stored field, under the stored field's name.
/// Every field may be missing. Field names are permanent once released: add fields, never rename or remove one.
public struct SavedCookEntry: Hashable, Sendable {
    public var stableID: UUID?
    /// The lesson id.
    public var lesson: String?
    /// The skill id the lesson taught.
    public var skill: String?
    public var level: Int?
    public var date: Date?
    public var stoppedEarly: Bool?
    /// Missing when the cook stopped early: only a finished cook has a quiz answer.
    public var quizCorrect: Bool?
    /// The cook's weekly goal at the time.
    public var weeklyGoal: Int?

    public init() {}

    public init(_ entry: CookEntry) {
        stableID = entry.id
        lesson = entry.lesson.id.rawValue
        skill = entry.lesson.skill.rawValue
        level = entry.lesson.level
        date = entry.session.date
        weeklyGoal = entry.session.weeklyGoal
        write(entry.session.result)
    }

    private mutating func write(_ result: CookResult) {
        switch result {
        case .finished(let quizCorrect):
            stoppedEarly = false
            self.quizCorrect = quizCorrect
        case .stoppedEarly:
            stoppedEarly = true
        }
    }
}
