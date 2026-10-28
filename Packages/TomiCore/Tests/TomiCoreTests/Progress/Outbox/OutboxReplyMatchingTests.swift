import Foundation
import Testing

@testable import TomiCore

/// The result counts for the cook that was sent only when it is that cook's. An answer that does not line up
/// changes nothing, so no cook is ever forgotten because of someone else's result.
@Suite struct OutboxReplyMatchingTests {
    let tests = OutboxReplyTests()
    let monday = CookEntry.fixture("knife", on: .october(5))
    let tuesday = CookEntry.fixture("knife", on: .october(6))

    @Test func aResultNamingTheSentCookChangesIt() throws {
        let reply = OutboxReply(sent: tests.sent(monday), result: try tests.result(monday.id, "accepted"))
        #expect(reply.change == .forget)
    }

    /// An entry the server could not read cannot block the outbox forever: it is refused.
    @Test func aResultWithoutAnIDChangesTheSentCook() throws {
        let result = try tests.result(nil, "rejected", problems: #""unreadable_entry""#)
        let reply = OutboxReply(sent: tests.sent(tuesday), result: result)
        #expect(reply.change == .refuse(code: "unreadable_entry"))
    }

    @Test func aResultNamingAnotherCookChangesNothing() throws {
        let reply = OutboxReply(sent: tests.sent(monday), result: try tests.result(tuesday.id, "accepted"))
        #expect(reply.change == nil)
    }

    @Test func aResultWithAStatusUnknownHereChangesNothing() throws {
        let reply = OutboxReply(sent: tests.sent(monday), result: try tests.result(monday.id, "parked"))
        #expect(reply.change == nil)
    }
}
