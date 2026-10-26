import Foundation
import Testing

@testable import TomiCore

/// A cook from the phone's log is sent as the server's example shows: with its own time zone,
/// and with no quiz result, XP or total, whatever the log says about the quiz.
@Suite struct CookEntryPayloadTests {
    /// The second entry of the backend's example: an old bundled lesson, cooked in Tokyo and stopped early.
    func exampleEntry() throws -> NSDictionary {
        let request = try ProgressJSON.object("request", of: ProgressJSON.cookEntries)
        let entries = try #require(request["entries"] as? [NSDictionary])
        return entries[1]
    }

    func savedCook(_ result: CookResult) -> CookEntry {
        let lesson = CookedLesson(id: "eggs-scrambled-1", skill: "eggs", level: 1)
        let date = UTCMoment().date(.october(12), hour: 11, minute: 5)
        let session = CookSession(date: date, result: result, weeklyGoal: 3)
        return CookEntry(
            id: UUID(uuidString: "5F3D3B1F-8F7C-4D8B-8D3C-7F1B4E2A0B22")!,
            lesson: lesson,
            session: session
        )
    }

    func sent(_ entry: CookEntry, in zone: String = "Asia/Tokyo") throws -> NSDictionary {
        let payload = CookEntryPayload(entry: entry, timeZone: TimeZone(identifier: zone)!)
        return try ProgressJSON.object(of: JSONEncoder().encode(payload))
    }

    @Test func aSavedCookIsSentAsTheExampleShowsIt() throws {
        #expect(try sent(savedCook(.stoppedEarly)) == (try exampleEntry()))
    }

    @Test func aFinishedCookSendsNoQuizResultXPOrTotal() throws {
        let sent = try sent(savedCook(.finished(quizCorrect: true)))
        let fields = Set(sent.allKeys.compactMap { $0 as? String })
        let expected: Set = ["schemaVersion", "id", "cookedAt", "timeZone", "dish", "skill", "level", "outcome"]
        #expect(fields == expected.union(["weeklyGoal"]))
        #expect(sent["outcome"] as? String == "finished")
    }

    @Test func eachCookCarriesTheZoneItWasCookedIn() throws {
        #expect(try sent(savedCook(.stoppedEarly), in: "America/New_York")["timeZone"] as? String == "America/New_York")
    }

    @Test func theIDIsWrittenInLowerCaseAsTheServerWritesIt() throws {
        #expect(try sent(savedCook(.stoppedEarly))["id"] as? String == "5f3d3b1f-8f7c-4d8b-8d3c-7f1b4e2a0b22")
    }

    @Test func aMomentWithinASecondIsSentToTheSecond() throws {
        let cook = savedCook(.stoppedEarly)
        let later = CookSession(date: cook.session.date.addingTimeInterval(0.25), result: .stoppedEarly, weeklyGoal: 3)
        let moved = CookEntry(id: cook.id, lesson: cook.lesson, session: later)
        #expect(try sent(moved)["cookedAt"] as? String == "2026-10-12T11:05:00Z")
    }
}
