import Foundation
import TomiCore

/// One cook and the answer to it, for the cook-entries route and the fake server.
enum CookEntryFixture {
    static let id = UUID(uuidString: "4E2C2A0E-7E6B-4C7A-9C2B-6E0A3D1F9A11")!

    /// A graph recipe cooked in Amsterdam on 26 October, as the phone sends it.
    static func request() -> CookEntryRequest {
        let calendar = CalendarContext(timeZone: "Europe/Amsterdam", firstWeekday: 2)
        return CookEntryRequest(calendar: calendar, entry: entry(id, day: 26))
    }

    /// The cook accepted, with the returning cook's snapshot.
    static func answerText(accepting request: CookEntryRequest) -> String {
        let id = request.entry.id.uuidString.lowercased()
        let result = #"{"id": ""# + id + #"", "status": "accepted"}"#
        return #"{"result": "# + result + #", "progress": "# + ProgressFixtureText.returning + "}"
    }

    private static func entry(_ id: UUID, day: Int) -> CookEntryPayload {
        let lesson = CookedLesson(id: "recipe/omelette-french", skill: "eggs", level: 1, graphVersion: "2026.10.20")
        let session = CookSession(date: .october(day), result: .finished(quizCorrect: true), weeklyGoal: 3)
        let cook = CookEntry(id: id, lesson: lesson, session: session)
        return CookEntryPayload(entry: cook, timeZone: TimeZone(identifier: "Europe/Amsterdam")!)!
    }
}
