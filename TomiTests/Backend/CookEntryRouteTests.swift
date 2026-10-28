import Foundation
import Testing
import TomiCore

@testable import Tomi

/// `POST /v1/cook-entries`: one cook with the cook's calendar as the body, the bearer token, and the answer read as
/// sent.
@Suite struct CookEntryRouteTests {
    let cook = CookEntryFixture.request()
    let answer = CookEntryFixture.answerText(accepting: CookEntryFixture.request())

    @Test func aCookIsSentWithTheBearerTokenAndTheCalendar() async throws {
        let harness = APIHarness.make([.init(status: 200, body: answer)])
        _ = try await harness.api.sendCookEntry(cook)
        let request = try #require(harness.transport.requests.first)
        #expect(request.httpMethod == "POST")
        #expect(request.url?.absoluteString == "https://api.example.test/v1/cook-entries")
        #expect(request.value(forHTTPHeaderField: "Authorization") == "Bearer old")
        #expect(request.value(forHTTPHeaderField: "Content-Type") == "application/json")
        let sent = try JSONDecoder().decode(CookEntryRequest.self, from: try #require(request.httpBody))
        #expect(sent == cook)
        #expect(sent.calendar == CalendarContext(timeZone: "Europe/Amsterdam", firstWeekday: 2))
    }

    @Test func theAnswerIsTheResultOfTheCookThatWasSent() async throws {
        let harness = APIHarness.make([.init(status: 200, body: answer)])
        let read = try await harness.api.sendCookEntry(cook).answer
        #expect(read.result.id == cook.entry.id)
        #expect(read.result.status == .accepted)
        #expect(read.progress?.xp == 350)
    }

    /// The store keeps the snapshot as the server sent it, so the answer hands over its JSON with it.
    @Test func theSnapshotComesWithItsJSON() async throws {
        let harness = APIHarness.make([.init(status: 200, body: answer)])
        let response = try await harness.api.sendCookEntry(cook)
        let body = try #require(response.snapshotBody)
        #expect(try JSONDecoder().decode(ProgressSnapshot.self, from: body) == response.answer.progress)
    }

    @Test func a401RenewsTheTokenOnceAndSendsTheSameCookAgain() async throws {
        let harness = APIHarness.make([.init(status: 401, body: ""), .init(status: 200, body: answer)])
        _ = try await harness.api.sendCookEntry(cook)
        #expect(harness.auth.renewalCount == 1)
        let bodies = harness.transport.requests.map(\.httpBody)
        #expect(bodies.count == 2)
        #expect(bodies[0] == bodies[1])
    }

    @Test func aRequestTheServerCannotReadIsTheServersInvalidRequest() async {
        let body = #"{"error": {"code": "invalid_request", "message": "Missing entry."}}"#
        let harness = APIHarness.make([.init(status: 422, body: body)])
        let expected = BackendError.server(
            status: 422,
            APIError(codeName: "invalid_request", message: "Missing entry.")
        )
        await #expect(throws: expected) {
            try await harness.api.sendCookEntry(cook)
        }
    }

    @Test(arguments: ["{}", #"{"result": "accepted"}"#, "not json"])
    func anAnswerThatCannotBeReadIsAnError(body: String) async {
        let harness = APIHarness.make([.init(status: 200, body: body)])
        await #expect(throws: BackendError.unreadableResponse(status: 200)) {
            try await harness.api.sendCookEntry(cook)
        }
    }

    @Test func noAnswerIsUnreachable() async {
        await #expect(throws: BackendError.unreachable) {
            try await APIHarness.make([]).api.sendCookEntry(cook)
        }
    }
}
