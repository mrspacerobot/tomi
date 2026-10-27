/// How a cook ended. Only a finished cook has a quiz answer, so a stopped one cannot claim a correct quiz.
public enum CookResult: Hashable, Sendable {
    case finished(quizCorrect: Bool)
    /// The cook left before the last step. Such an entry is kept, but it never counts as a cook.
    case stoppedEarly
}
