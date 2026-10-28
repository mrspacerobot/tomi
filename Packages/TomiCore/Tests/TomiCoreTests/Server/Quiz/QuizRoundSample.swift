import Foundation
import Testing

@testable import TomiCore

/// A round of invented questions, so no test says which choice of a real graph question is right.
enum QuizRoundSample {
    static let spoon = "technique/scramble/quiz/fake-spoon"
    static let bell = "technique/scramble/quiz/fake-bell"

    static let questions =
        #"[{"id": "technique/scramble/quiz/fake-spoon", "question": "Which spoon?", "#
        + #""choices": ["Wooden", "Metal", "Plastic"], "tier": "drafted"}, "#
        + #"{"id": "technique/scramble/quiz/fake-bell", "question": "Which bell?", "#
        + #""choices": ["Small", "Large"], "tier": "drafted"}]"#

    static func round() throws -> QuizRound {
        let decoded = try ServerJSON.decode([TeachingQuestion].self, from: questions)
        return try #require(QuizRound(sitting: QuizJSON.sitting, questions: decoded))
    }

    static func verdict(_ question: String, correct: Bool) throws -> QuizVerdict {
        var text = #"{"questionId": "\#(question)", "correct": \#(correct), "scored": true, "#
        text += #""explanation": "Invented explanation."}"#
        return try ServerJSON.decode(QuizVerdict.self, from: text)
    }
}
