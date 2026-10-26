import Foundation
import Testing

@testable import TomiCore

/// The server answers in the order the cooks were sent. An answer that does not line up with the batch
/// changes nothing, so no cook is ever forgotten because of someone else's result.
@Suite struct OutboxReplyMatchingTests {
    let tests = OutboxReplyTests()
    let monday = CookEntry.fixture("knife", on: .october(5))
    let tuesday = CookEntry.fixture("knife", on: .october(6))

    @Test func eachResultChangesTheCookSentInItsPlace() throws {
        let results = [try tests.result(monday.id, "accepted"), try tests.result(tuesday.id, "parked")]
        let reply = OutboxReply(sent: tests.sent([monday, tuesday]), results: results)
        #expect(reply.changes == [monday.id: .forget])
    }

    /// One entry the server could not read cannot block the outbox forever: it is refused in its place.
    @Test func aResultWithoutAnIDChangesTheCookSentInItsPlace() throws {
        let results = [
            try tests.result(monday.id, "accepted"),
            try tests.result(nil, "rejected", problems: #""unreadable_entry""#),
        ]
        let reply = OutboxReply(sent: tests.sent([monday, tuesday]), results: results)
        #expect(reply.changes == [monday.id: .forget, tuesday.id: .refuse(code: "unreadable_entry")])
    }

    @Test func aResultNamingAnotherCookChangesNothingForIt() throws {
        let results = [try tests.result(tuesday.id, "accepted"), try tests.result(monday.id, "accepted")]
        let reply = OutboxReply(sent: tests.sent([monday, tuesday]), results: results)
        #expect(reply.changes == [:])
    }

    @Test func anAnswerWithMoreOrFewerResultsThanCooksChangesNothing() throws {
        let sent = tests.sent([monday, tuesday])
        let one = OutboxReply(sent: sent, results: [try tests.result(monday.id, "accepted")])
        let three = OutboxReply(sent: sent, results: Array(repeating: try tests.result(nil, "accepted"), count: 3))
        #expect(one.changes == [:])
        #expect(three.changes == [:])
    }
}
