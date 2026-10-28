import Foundation
import TomiCore

/// Marks picks as the server does: right or wrong from the quiz, the explanation only once right, and the first
/// pick of each question in a cook as the score. A later, different pick only teaches; the same first pick again
/// is a retry and answered as the first time.
nonisolated struct FakeQuizMarking: Sendable {
    let quiz: FakeQuiz
    private var firstPicks: [FakeQuizPickKey: Int] = [:]

    init(quiz: FakeQuiz) {
        self.quiz = quiz
    }

    mutating func verdict(for pick: QuizPick) throws -> QuizVerdict {
        guard let question = quiz.question(pick.questionID), question.offers(pick.choice) else {
            throw Self.invalidRequest
        }
        let key = FakeQuizPickKey(entryID: pick.sitting.entryID, questionID: pick.questionID)
        let first = firstPicks[key] ?? pick.choice
        firstPicks[key] = first
        let body = FakeQuizVerdictBody(question: question, choice: pick.choice, isScored: first == pick.choice)
        return try body.verdict()
    }

    private static let invalidRequest = BackendError.server(
        status: 422,
        APIError(codeName: APIErrorCode.invalidRequest.rawValue, message: "The question or choice is not in the quiz.")
    )
}
