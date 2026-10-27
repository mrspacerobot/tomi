import Foundation
import Testing

@testable import TomiCore

/// A pick is sent as `POST /v1/quiz-answers` reads it, and carries nothing of a result of its own.
@Suite struct QuizPickTests {
    let pick = QuizPick(sitting: QuizJSON.sitting, questionID: "technique/scramble/quiz/purpose", choice: 0)

    func object(_ data: Data) throws -> NSDictionary {
        try #require(try JSONSerialization.jsonObject(with: data) as? NSDictionary)
    }

    @Test func aPickIsTheBackendsExampleExactly() throws {
        let sent = try object(try JSONEncoder().encode(pick))
        let example = try object(Data(QuizJSON.request.utf8))
        #expect(sent == example)
    }

    @Test func theEntryIDIsSentInLowerCaseAsTheServerWritesIt() throws {
        let sent = try object(try JSONEncoder().encode(pick))
        #expect(sent["entryId"] as? String == "4e2c2a0e-7e6b-4c7a-9c2b-6e0a3d1f9a11")
    }

    @Test func aPickSendsNoResultOfItsOwn() throws {
        let sent = try object(try JSONEncoder().encode(pick))
        let keys = Set(sent.allKeys.compactMap { $0 as? String })
        #expect(keys == ["entryId", "recipeId", "graphVersion", "questionId", "choice"])
    }
}
