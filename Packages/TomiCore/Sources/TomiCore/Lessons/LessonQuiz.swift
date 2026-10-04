/// The one question asked at the end of a lesson.
public struct LessonQuiz: Hashable, Codable, Sendable {
    /// A question with a single answer is not a question.
    public static let fewestAnswers = 2

    public var question: LocalizedText
    public var answers: [LocalizedText]
    /// Where the right answer sits in `answers`, counting from 0. A file that leaves it out still decodes,
    /// so the validator can report it with the lesson.
    public var correctAnswer: Int?
    /// Shown after the cook answers, right or wrong.
    public var explanation: LocalizedText
}
