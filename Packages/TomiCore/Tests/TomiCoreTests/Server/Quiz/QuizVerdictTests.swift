import Testing

@testable import TomiCore

/// The server's word on one pick: right or wrong, whether it is the score, and the explanation once right.
@Suite struct QuizVerdictTests {
    let pick = QuizPick(sitting: QuizJSON.sitting, questionID: "technique/scramble/quiz/fake-spoon", choice: 1)

    @Test func aRightPickIsReadWithItsExplanation() throws {
        let verdict = try ServerJSON.decode(QuizVerdict.self, from: QuizJSON.right)
        #expect(verdict.questionID == "technique/scramble/quiz/fake-spoon")
        #expect(verdict.isCorrect)
        #expect(verdict.isScored)
        #expect(verdict.explanation == "In the test kitchen Tomi stirs with a wooden spoon.")
    }

    @Test func aRightPickWithoutAnExplanationIsStillRead() throws {
        let verdict = try ServerJSON.decode(QuizVerdict.self, from: QuizJSON.rightWithoutExplanation)
        #expect(verdict.isCorrect)
        #expect(!verdict.isScored)
        #expect(verdict.explanation == nil)
    }

    @Test func aWrongPickIsReadWithoutAnExplanation() throws {
        let verdict = try ServerJSON.decode(QuizVerdict.self, from: QuizJSON.wrong)
        #expect(!verdict.isCorrect)
        #expect(verdict.explanation == nil)
    }

    @Test func anExplanationSentWithAWrongPickIsNeverKept() throws {
        let verdict = try ServerJSON.decode(QuizVerdict.self, from: QuizJSON.wrongWithAnExplanation)
        #expect(!verdict.isCorrect)
        #expect(verdict.explanation == nil)
    }

    @Test(arguments: [QuizJSON.withoutCorrect, QuizJSON.withoutScored, "{}", "not json"])
    func anAnswerMissingWhatItMustSayIsRefused(text: String) {
        #expect(throws: (any Error).self) {
            try ServerJSON.decode(QuizVerdict.self, from: text)
        }
    }

    @Test func aVerdictAnswersThePickOfItsQuestionOnly() throws {
        let verdict = try ServerJSON.decode(QuizVerdict.self, from: QuizJSON.right)
        let other = QuizPick(sitting: QuizJSON.sitting, questionID: "technique/scramble/quiz/other", choice: 1)
        #expect(verdict.answers(pick))
        #expect(!verdict.answers(other))
    }
}
