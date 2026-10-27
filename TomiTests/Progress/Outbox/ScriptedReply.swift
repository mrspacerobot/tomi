import Foundation
import TomiCore

@testable import Tomi

/// Answers the scripted server gives a batch.
enum ScriptedReply {
    /// Every cook in the batch with these statuses, in order, and the returning cook's snapshot as sent.
    static func answering(_ results: [CookEntryStatus], problems: [CookEntryProblem] = []) -> ScriptedAnswer {
        { request in
            let answers = zip(request.entries, results).map { cook, status in
                CookEntryResult(id: cook.id, status: status, problems: problems)
            }
            let fixture = FakeProgressFixture.returning
            let answer = CookEntriesAnswer(results: answers, progress: try fixture.snapshot())
            return CookEntriesResponse(answer: answer, snapshotBody: try fixture.body())
        }
    }

    /// Every cook in the batch accepted.
    static let acceptingAll: ScriptedAnswer = { request in
        try answering(Array(repeating: .accepted, count: request.entries.count))(request)
    }

    static func failing(_ error: BackendError) -> ScriptedAnswer {
        { _ in throw error }
    }

    /// The server's answer to a batch it could not read.
    static let invalidRequest = failing(
        .server(status: 422, APIError(codeName: "invalid_request", message: "The batch could not be read."))
    )
}
