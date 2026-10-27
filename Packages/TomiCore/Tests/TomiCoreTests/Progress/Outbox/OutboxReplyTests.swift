import Foundation
import Testing

@testable import TomiCore

/// What the server's answer for each sent cook does to the outbox.
@Suite struct OutboxReplyTests {
    let calendar = TestCalendar().calendar
    let cook = CookEntry.fixture("eggs")

    func sent(_ cooks: [CookEntry]) -> [CookEntryPayload] {
        cooks.map { SavedCookEntry($0) }.outboxBatch(for: CookEntry.fixtureAccount, calendar: calendar).entries
    }

    func result(_ id: UUID?, _ status: String, problems: String = "") throws -> CookEntryResult {
        var idText = "null"
        if let id {
            idText = "\"\(id.uuidString.lowercased())\""
        }
        let text = #"{"id": \#(idText), "status": "\#(status)", "problems": [\#(problems)]}"#
        return try JSONDecoder().decode(CookEntryResult.self, from: Data(text.utf8))
    }

    func change(for status: String, problems: String = "") throws -> OutboxChange? {
        let reply = OutboxReply(sent: sent([cook]), results: [try result(cook.id, status, problems: problems)])
        return reply.changes[cook.id]
    }

    @Test func anAcceptedCookIsForgotten() throws {
        #expect(try change(for: "accepted") == .forget)
    }

    @Test func aDuplicateCookIsForgotten() throws {
        #expect(try change(for: "duplicate") == .forget)
    }

    /// The server kept the first copy and counts it. Sending this one again would change nothing.
    @Test func aConflictingCookIsForgotten() throws {
        #expect(try change(for: "conflict") == .forget)
    }

    @Test func aRejectedCookIsMarkedRefusedWithItsCode() throws {
        let change = try change(for: "rejected", problems: #""cooked_in_future", "invalid_time_zone""#)
        #expect(change == .refuse(code: "cooked_in_future"))
    }

    @Test func aRejectedCookWithoutACodeIsStillRefused() throws {
        #expect(try change(for: "rejected") == .refuse(code: CookOutbox.unstatedProblem))
    }

    @Test func aCookWithAStatusUnknownHereIsKept() throws {
        #expect(try change(for: "parked") == nil)
    }
}
