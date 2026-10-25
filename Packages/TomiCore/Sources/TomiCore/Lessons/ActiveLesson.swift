/// The lesson the cook is in the middle of, kept so that it survives the app being closed.
/// It is a bookmark, not a copy: it names the lesson and the swaps applied, and `resumed(from:)`
/// builds the dish again from the library, so a lesson that was corrected or withdrawn is never cooked from memory.
public struct ActiveLesson: Hashable, Sendable {
    public var lesson: LessonID
    /// The revision of the lesson the cook started. Another revision may have other steps.
    public var revision: Int
    /// The swaps applied to the lesson, in the order they were applied.
    public var swaps: [AppliedSwap] = []
    /// What the cook confirmed they have tonight.
    public var ingredients: Set<IngredientID> = []
    /// The step the cook is on, counting from 0.
    public var currentStep = 0

    public init(lesson: LessonID, revision: Int) {
        self.lesson = lesson
        self.revision = revision
    }
}
