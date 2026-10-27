import Foundation
import Testing
import TomiCore

@testable import Tomi

/// `POST /v1/cook-entries`: the batch with the cook's calendar as the body, the bearer token, and the answer read
/// as sent, results in order.
@Suite struct CookEntriesRouteTests {
    let batch = CookEntriesFixture.batch()
    let answer = CookEntriesFixture.answerText(acceptingAll: CookEntriesFixture.batch())

    @Test func cooksAreSentWithTheBearerTokenAndTheCalendar() async throws {
        let harness = APIHarness.make([.init(status: 200, body: answer)])
        _ = try await harness.api.sendCookEntries(batch)
        let request = try #require(harness.transport.requests.first)
        #expect(request.httpMethod == "POST")
        #expect(request.url?.absoluteString == "https://api.example.test/v1/cook-entries")
        #expect(request.value(forHTTPHeaderField: "Authorization") == "Bearer old")
        #expect(request.value(forHTTPHeaderField: "Content-Type") == "application/json")
        let sent = try JSONDecoder().decode(CookEntriesRequest.self, from: try #require(request.httpBody))
        #expect(sent == batch)
        #expect(sent.calendar == CalendarContext(timeZone: "Europe/Amsterdam", firstWeekday: 2))
    }

    @Test func theAnswerIsReadInTheOrderTheCooksWereSent() async throws {
        let harness = APIHarness.make([.init(status: 200, body: answer)])
        let read = try await harness.api.sendCookEntries(batch)
        #expect(read.results.map(\.id) == batch.entries.map(\.id))
        #expect(read.results.map(\.status) == [.accepted, .accepted])
        #expect(read.progress?.xp == 350)
    }

    @Test func a401RenewsTheTokenOnceAndSendsTheSameBatchAgain() async throws {
        let harness = APIHarness.make([.init(status: 401, body: ""), .init(status: 200, body: answer)])
        _ = try await harness.api.sendCookEntries(batch)
        #expect(harness.auth.renewalCount == 1)
        let bodies = harness.transport.requests.map(\.httpBody)
        #expect(bodies.count == 2)
        #expect(bodies[0] == bodies[1])
    }

    @Test func aBatchTheServerCannotReadIsTheServersInvalidRequest() async {
        let body = #"{"error": {"code": "invalid_request", "message": "Too many entries."}}"#
        let harness = APIHarness.make([.init(status: 422, body: body)])
        let expected = BackendError.server(
            status: 422,
            APIError(codeName: "invalid_request", message: "Too many entries.")
        )
        await #expect(throws: expected) {
            try await harness.api.sendCookEntries(batch)
        }
    }

    @Test(arguments: ["{}", #"{"results": "accepted"}"#, "not json"])
    func anAnswerThatCannotBeReadIsAnError(body: String) async {
        let harness = APIHarness.make([.init(status: 200, body: body)])
        await #expect(throws: BackendError.unreadableResponse(status: 200)) {
            try await harness.api.sendCookEntries(batch)
        }
    }

    @Test func noAnswerIsUnreachable() async {
        await #expect(throws: BackendError.unreachable) {
            try await APIHarness.make([]).api.sendCookEntries(batch)
        }
    }
}
