import Foundation

/// Invented quiz questions with their right choices, for the fake server. The file lives with the UI tests
/// (`TomiUITests/Fixtures/fake-quiz.json`) and reaches the app only by launch argument, so the app ships no
/// right choice and no quiz at all when none is handed over.
nonisolated struct FakeQuiz: Decodable, Sendable {
    let questions: [FakeQuizQuestion]

    static func decode(from text: String) throws -> FakeQuiz {
        try JSONDecoder().decode(FakeQuiz.self, from: Data(text.utf8))
    }

    func question(_ id: String) -> FakeQuizQuestion? {
        questions.first { $0.id == id }
    }

    /// The questions as the server sends them in a suggestion's teaching: without their right choices.
    var teachingQuestions: [[String: Any]] {
        questions.map(\.teachingQuestion)
    }
}
