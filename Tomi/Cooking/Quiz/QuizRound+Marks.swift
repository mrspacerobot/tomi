import TomiCore

extension QuizRound {
    /// The question the cook is on, among all the questions.
    var marks: CookingMarks {
        CookingMarks(position: position, count: count)
    }
}
