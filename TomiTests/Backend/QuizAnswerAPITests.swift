import Foundation
import Testing
import TomiCore

@testable import Tomi

/// `POST /v1/quiz-answers` over the client: one pick out, the server's right or wrong back.
@Suite struct QuizAnswerAPITests {
    static let sitting = QuizSitting(
        entryID: UUID(uuidString: "4e2c2a0e-7e6b-4c7a-9c2b-6e0a3d1f9a11")!,
        recipeID: "recipe/soft-scrambled-eggs",
        graphVersion: "2026.10.22-8aa9532"
    )
    static let pick = QuizPick(sitting: sitting, questionID: "technique/scramble/quiz/purpose", choice: 0)
    static let example =
        #"{"entryId": "4e2c2a0e-7e6b-4c7a-9c2b-6e0a3d1f9a11", "recipeId": "recipe/soft-scrambled-eggs", "#
        + #""graphVersion": "2026.10.22-8aa9532", "questionId": "technique/scramble/quiz/purpose", "choice": 0}"#
    static let right =
        #"{"questionId": "technique/scramble/quiz/purpose", "correct": true, "scored": true, "#
        + #""explanation": "Invented for this test."}"#

    func object(_ data: Data?) throws -> NSDictionary {
        let data = try #require(data)
        return try #require(try JSONSerialization.jsonObject(with: data) as? NSDictionary)
    }

    @Test func aPickIsPostedWithTheTokenAndTheExampleBody() async throws {
        let harness = APIHarness([.init(status: 200, body: Self.right)])
        _ = try await harness.api.answerQuiz(Self.pick)
        let request = try #require(harness.transport.requests.first)
        #expect(request.httpMethod == "POST")
        #expect(request.url?.absoluteString == "https://api.example.test/v1/quiz-answers")
        #expect(request.value(forHTTPHeaderField: "Authorization") == "Bearer old")
        #expect(request.value(forHTTPHeaderField: "Content-Type") == "application/json")
        #expect(try object(request.httpBody) == object(Data(Self.example.utf8)))
    }

    @Test func theServersAnswerIsRead() async throws {
        let harness = APIHarness([.init(status: 200, body: Self.right)])
        let verdict = try await harness.api.answerQuiz(Self.pick)
        #expect(verdict.isCorrect)
        #expect(verdict.isScored)
        #expect(verdict.explanation == "Invented for this test.")
    }

    @Test func aChangedGraphIsATypedError() async {
        let body = #"{"error": {"code": "graph_version_changed", "message": "New graph."}}"#
        let harness = APIHarness([.init(status: 409, body: body)])
        await #expect {
            try await harness.api.answerQuiz(Self.pick)
        } throws: { error in
            (error as? BackendError)?.code == .graphVersionChanged
        }
    }

    @Test func anAnswerToAnotherQuestionIsRefused() async {
        let other = #"{"questionId": "technique/scramble/quiz/other", "correct": true, "scored": true}"#
        let harness = APIHarness([.init(status: 200, body: other)])
        await #expect(throws: BackendError.unreadableResponse(status: 200)) {
            try await harness.api.answerQuiz(Self.pick)
        }
    }

    @Test func anAnswerWithoutRightOrWrongIsRefused() async {
        let missing = #"{"questionId": "technique/scramble/quiz/purpose", "scored": true}"#
        let harness = APIHarness([.init(status: 200, body: missing)])
        await #expect(throws: BackendError.unreadableResponse(status: 200)) {
            try await harness.api.answerQuiz(Self.pick)
        }
    }

    @Test func noConnectionIsUnreachable() async {
        await #expect(throws: BackendError.unreachable) {
            try await APIHarness([]).api.answerQuiz(Self.pick)
        }
    }
}
