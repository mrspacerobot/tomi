/// A lesson in progress, built again from the library and checked again, ready for the player.
public struct ResumedLesson: Hashable, Sendable {
    /// The lesson with the cook's swaps applied.
    public let lesson: Lesson
    public let ingredients: Set<IngredientID>
    /// The step to open on, counting from 0. Always a step of the lesson.
    public let currentStep: Int
}
