import Foundation
import Testing
import TomiCore

@testable import Tomi

/// How a failed call is put to the outbox rules. What follows is decided in TomiCore (`OutboxWaitTests`).
@Suite struct BackendErrorOutboxTests {
    func server(_ status: Int) -> BackendError {
        .server(status: status, APIError(codeName: "any_code", message: "A problem."))
    }

    @Test func aBatchTheServerCannotReadIsToldApart() {
        #expect(server(422).outboxFailure == .batchUnreadable)
    }

    @Test func nobodySignedInIsToldApart() {
        #expect(BackendError.notSignedIn.outboxFailure == .notSignedIn)
    }

    @Test(arguments: [400, 401, 409, 429, 500, 503])
    func anyOtherServerAnswerIsAnotherFailure(status: Int) {
        #expect(server(status).outboxFailure == .other)
    }

    @Test func aPhoneThatCannotReachTheServerOrReadItsAnswerIsAnotherFailure() {
        #expect(BackendError.unreachable.outboxFailure == .other)
        #expect(BackendError.unreadableResponse(status: 200).outboxFailure == .other)
        #expect(BackendError.notConfigured.outboxFailure == .other)
    }
}
