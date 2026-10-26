import Foundation
import Testing

@testable import TomiCore

/// The backend's example of `POST /v1/cook-entries`, request and answer, read and written as the server does.
@Suite struct CookEntriesExampleTests {
    func request() throws -> CookEntriesRequest {
        let text = String(data: try JSONSerialization.data(withJSONObject: try requestObject()), encoding: .utf8)!
        return try ServerJSON.decode(CookEntriesRequest.self, from: text)
    }

    func requestObject() throws -> NSDictionary {
        try ProgressJSON.object("request", of: ProgressJSON.cookEntries)
    }

    @Test func theExampleRequestIsRead() throws {
        let request = try request()
        #expect(request.calendar == CalendarContext(timeZone: "Europe/Amsterdam", firstWeekday: 2))
        #expect(request.entries.map(\.timeZone) == ["Europe/Amsterdam", "Asia/Tokyo", "Europe/Amsterdam"])
        #expect(request.entries.map(\.outcome) == [.finished, .stoppedEarly, .finished])
        #expect(request.entries.first?.dish == .recipe("recipe/omelette-french", graphVersion: "2026.10.20"))
        #expect(request.entries.last?.dish == .lesson("eggs-scrambled-1"))
        #expect(request.entries.first?.cookedAt.date == UTCMoment().date(.october(20), hour: 18, minute: 42))
    }

    @Test func theExampleRequestIsWrittenBackExactlyAsTheServerWroteIt() throws {
        let written = try ProgressJSON.object(of: JSONEncoder().encode(try request()))
        #expect(written == (try requestObject()))
    }

    @Test func theExampleAnswerIsReadInRequestOrder() throws {
        let text = String(data: try JSONSerialization.data(withJSONObject: try answerObject()), encoding: .utf8)!
        let answer = try ServerJSON.decode(CookEntriesAnswer.self, from: text)
        #expect(answer.results.map(\.status) == [.accepted, .accepted, .rejected])
        #expect(answer.results.map(\.id) == (try request()).entries.map(\.id))
        #expect(answer.results.last?.problems == ["cooked_in_future"])
        #expect(answer.results.first?.problems == [])
        #expect(answer.progress == nil)
    }

    func answerObject() throws -> NSDictionary {
        try ProgressJSON.object("response", of: ProgressJSON.cookEntries)
    }
}
