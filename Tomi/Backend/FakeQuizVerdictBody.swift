import Foundation
import TomiCore

/// The fake server's answer body, written as the real server writes it and read back through the same rules,
/// so the app reads the fake's answers exactly as it reads the server's.
nonisolated struct FakeQuizVerdictBody: Encodable {
    let questionId: String
    let correct: Bool
    let scored: Bool
    let explanation: String?

    init(question: FakeQuizQuestion, choice: Int, isScored: Bool) {
        questionId = question.id
        correct = question.rightChoice == choice
        scored = isScored
        explanation = Self.explanation(of: question, correct: correct)
    }

    private static func explanation(of question: FakeQuizQuestion, correct: Bool) -> String? {
        guard correct else {
            return nil
        }
        return question.explanation
    }

    func verdict() throws -> QuizVerdict {
        try JSONDecoder().decode(QuizVerdict.self, from: JSONEncoder().encode(self))
    }
}
