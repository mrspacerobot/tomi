import Foundation
import Testing

@testable import TomiCore

/// The backend's example of `POST /v1/cook-entries`, request and answer, read and written as the server does.
@Suite struct CookEntryExampleTests {
    func request() throws -> CookEntryRequest {
        let text = String(data: try JSONSerialization.data(withJSONObject: try requestObject()), encoding: .utf8)!
        return try ServerJSON.decode(CookEntryRequest.self, from: text)
    }

    func requestObject() throws -> NSDictionary {
        try ProgressJSON.object("request", of: ProgressJSON.cookEntries)
    }

    func answerObject() throws -> NSDictionary {
        try ProgressJSON.object("response", of: ProgressJSON.cookEntries)
    }

    @Test func theExampleRequestHoldsOneCookAndTheCalendar() throws {
        let request = try request()
        #expect(request.calendar == CalendarContext(timeZone: "Europe/Amsterdam", firstWeekday: 2))
        #expect(request.entry.timeZone == "Europe/Amsterdam")
        #expect(request.entry.outcome == .finished)
        #expect(request.entry.dish == CookedDish(recipe: "recipe/omelette-french", graphVersion: "2026.10.20"))
        #expect(request.entry.cookedAt.date == UTCMoment().date(.october(20), hour: 18, minute: 42))
    }

    @Test func theExampleRequestIsWrittenBackExactlyAsTheServerWroteIt() throws {
        let written = try ProgressJSON.object(of: JSONEncoder().encode(try request()))
        #expect(written == (try requestObject()))
    }

    @Test func theExampleAnswerIsTheResultOfTheEntryAndTheSnapshot() throws {
        let text = String(data: try JSONSerialization.data(withJSONObject: try answerObject()), encoding: .utf8)!
        let answer = try ServerJSON.decode(CookEntryAnswer.self, from: text)
        #expect(answer.result.status == .accepted)
        #expect(answer.result.id == (try request()).entry.id)
        #expect(answer.result.problems == [])
        #expect(answer.progress?.xp == 50)
    }
}
