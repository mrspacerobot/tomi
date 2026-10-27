import Foundation
import Testing
import TomiCore

@testable import Tomi

/// `GET /v1/progress`: the cook's calendar in the query, the bearer token, and the snapshot read exactly as sent.
@Suite struct ProgressRouteTests {
    let amsterdam = CalendarContext(timeZone: "Europe/Amsterdam", firstWeekday: 2)
    let snapshot = ProgressFixtureText.returning

    @Test func progressIsAskedWithTheCalendarInTheQuery() async throws {
        let harness = APIHarness.make([.init(status: 200, body: snapshot)])
        _ = try await harness.api.progress(amsterdam)
        let url = try #require(harness.transport.requests.first?.url)
        let components = try #require(URLComponents(url: url, resolvingAgainstBaseURL: false))
        #expect(components.path == "/v1/progress")
        let expected = [
            URLQueryItem(name: "timeZone", value: "Europe/Amsterdam"), URLQueryItem(name: "firstWeekday", value: "2"),
        ]
        #expect(components.queryItems == expected)
    }

    @Test func progressIsAskedWithTheBearerToken() async throws {
        let harness = APIHarness.make([.init(status: 200, body: snapshot)])
        _ = try await harness.api.progress(amsterdam)
        let request = try #require(harness.transport.requests.first)
        #expect(request.httpMethod == "GET")
        #expect(request.value(forHTTPHeaderField: "Authorization") == "Bearer old")
        #expect(request.httpBody == nil)
    }

    /// A plus in a query is read as a space by the server, so `Etc/GMT+5` must travel as `%2B`.
    @Test func aZoneWithAPlusReachesTheServerUnchanged() async throws {
        let harness = APIHarness.make([.init(status: 200, body: snapshot)])
        _ = try await harness.api.progress(CalendarContext(timeZone: "Etc/GMT+5", firstWeekday: 1))
        let query = try #require(harness.transport.requests.first?.url?.query(percentEncoded: true))
        #expect(query == "timeZone=Etc/GMT%2B5&firstWeekday=1")
    }

    @Test func theSnapshotIsReadAsTheServerSentIt() async throws {
        let harness = APIHarness.make([.init(status: 200, body: snapshot)])
        let read = try await harness.api.progress(amsterdam)
        #expect(read == (try JSONDecoder().decode(ProgressSnapshot.self, from: Data(snapshot.utf8))))
        #expect(read.xp == 350)
    }

    @Test func a401RenewsTheTokenOnceAndAsksAgain() async throws {
        let harness = APIHarness.make([.init(status: 401, body: ""), .init(status: 200, body: snapshot)])
        _ = try await harness.api.progress(amsterdam)
        #expect(harness.auth.renewalCount == 1)
        let tokens = harness.transport.requests.map { $0.value(forHTTPHeaderField: "Authorization") }
        #expect(tokens == ["Bearer old", "Bearer new"])
    }

    @Test func aBadCalendarIsTheServersInvalidRequest() async {
        let body = #"{"error": {"code": "invalid_request", "message": "Unknown zone."}}"#
        let harness = APIHarness.make([.init(status: 422, body: body)])
        let expected = BackendError.server(status: 422, APIError(codeName: "invalid_request", message: "Unknown zone."))
        await #expect(throws: expected) {
            try await harness.api.progress(amsterdam)
        }
    }

    /// An answer that cannot be read is an error, never a snapshot of zeros.
    @Test(arguments: [#"{"schemaVersion": 2}"#, "{}", #"{"schemaVersion": 1, "xp": 10}"#, "not json"])
    func anAnswerThatCannotBeReadIsAnError(body: String) async {
        let harness = APIHarness.make([.init(status: 200, body: body)])
        await #expect(throws: BackendError.unreadableResponse(status: 200)) {
            try await harness.api.progress(amsterdam)
        }
    }
}
