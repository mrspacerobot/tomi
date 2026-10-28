import Foundation
import TomiCore

@testable import Tomi

/// Answers the scripted server gives a request.
enum ScriptedReply {
    /// The cook sent, with this status, and the returning cook's snapshot as sent.
    static func answering(_ status: CookEntryStatus, problems: [CookEntryProblem] = []) -> ScriptedAnswer {
        { request in
            let result = CookEntryResult(id: request.entry.id, status: status, problems: problems)
            let fixture = FakeProgressFixture.returning
            let answer = CookEntryAnswer(result: result, progress: try fixture.snapshot())
            return CookEntryResponse(answer: answer, snapshotBody: try fixture.body())
        }
    }

    /// The cook sent, accepted.
    static let accepting: ScriptedAnswer = answering(.accepted)

    static func failing(_ error: BackendError) -> ScriptedAnswer {
        { _ in throw error }
    }

    /// The server's answer to a request it could not read.
    static let invalidRequest = failing(
        .server(status: 422, APIError(codeName: "invalid_request", message: "The request could not be read."))
    )
}
