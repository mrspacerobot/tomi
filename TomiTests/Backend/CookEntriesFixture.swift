import Foundation
import TomiCore

/// A batch of two cooks and answers to it, for the cook-entries route and the fake server.
enum CookEntriesFixture {
    static func batch() -> CookEntriesRequest {
        let first = UUID(uuidString: "4E2C2A0E-7E6B-4C7A-9C2B-6E0A3D1F9A11")!
        let second = UUID(uuidString: "9B1F0C4D-2A3E-4F5B-8C6D-7E8F9A0B1C2D")!
        let calendar = CalendarContext(timeZone: "Europe/Amsterdam", firstWeekday: 2)
        return CookEntriesRequest(calendar: calendar, entries: [entry(first, day: 26), entry(second, day: 27)])
    }

    /// Every cook of the batch accepted, with the returning cook's snapshot.
    static func answerText(acceptingAll batch: CookEntriesRequest) -> String {
        let results = batch.entries.map { #"{"id": ""# + $0.id.uuidString.lowercased() + #"", "status": "accepted"}"# }
        return #"{"results": ["# + results.joined(separator: ", ") + #"], "progress": "# + ProgressFixtureText.returning
            + "}"
    }

    private static func entry(_ id: UUID, day: Int) -> CookEntryPayload {
        let lesson = CookedLesson(id: "a-lesson", skill: "eggs", level: 1)
        let session = CookSession(date: .october(day), result: .finished(quizCorrect: true), weeklyGoal: 3)
        let cook = CookEntry(id: id, lesson: lesson, session: session)
        return CookEntryPayload(entry: cook, timeZone: TimeZone(identifier: "Europe/Amsterdam")!)
    }
}
