/// A place in a lesson that holds words the cook reads. Steps and answers are found by where they sit
/// in their list, counting from 0.
public enum LessonTextField: Hashable, Sendable {
    case title
    case whyThis
    case concept
    case stepText(step: Int)
    case stepTip(step: Int)
    case quizQuestion
    case quizAnswer(answer: Int)
    case quizExplanation
}
