extension LessonQuiz {
    /// The problems of the quiz: it must offer a choice and say which answer is right.
    var issues: [LessonIssue] {
        var issues: [LessonIssue] = []
        if answers.count < LessonQuiz.fewestAnswers {
            issues.append(.tooFewAnswers)
        }
        guard let correctAnswer else {
            return issues + [.noCorrectAnswer]
        }
        if !answers.indices.contains(correctAnswer) {
            issues.append(.correctAnswerOutOfRange(correctAnswer))
        }
        return issues
    }
}
