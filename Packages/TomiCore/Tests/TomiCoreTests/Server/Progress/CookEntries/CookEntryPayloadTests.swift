import Foundation
import Testing

@testable import TomiCore

/// A cook from the phone's log is sent as the server's example shows: with its own time zone, its graph recipe,
/// and with no quiz result, XP or total, whatever the log says about the quiz.
@Suite struct CookEntryPayloadTests {
    /// The entry of the backend's example: a graph recipe, cooked in Amsterdam and finished.
    func exampleEntry() throws -> NSDictionary {
        let request = try ProgressJSON.object("request", of: ProgressJSON.cookEntries)
        return try #require(request["entry"] as? NSDictionary)
    }

    func savedCook(_ result: CookResult = .finished(quizCorrect: true)) -> CookEntry {
        let lesson = CookedLesson(id: "recipe/omelette-french", skill: "eggs", level: 1, graphVersion: "2026.10.20")
        let date = UTCMoment().date(.october(20), hour: 18, minute: 42)
        let session = CookSession(date: date, result: result, weeklyGoal: 3)
        return CookEntry(
            id: UUID(uuidString: "4E2C2A0E-7E6B-4C7A-9C2B-6E0A3D1F9A11")!,
            lesson: lesson,
            session: session
        )
    }

    func sent(_ entry: CookEntry, in zone: String = "Europe/Amsterdam") throws -> NSDictionary {
        let payload = try #require(CookEntryPayload(entry: entry, timeZone: TimeZone(identifier: zone)!))
        return try ProgressJSON.object(of: JSONEncoder().encode(payload))
    }

    @Test func aSavedCookIsSentAsTheExampleShowsIt() throws {
        #expect(try sent(savedCook()) == (try exampleEntry()))
    }

    @Test func aCookSendsNoQuizResultXPOrTotalWhateverTheLogSaysAboutTheQuiz() throws {
        for quizCorrect in [true, false] {
            let sent = try sent(savedCook(.finished(quizCorrect: quizCorrect)))
            let fields = Set(sent.allKeys.compactMap { $0 as? String })
            let expected: Set = ["schemaVersion", "id", "cookedAt", "timeZone", "dish", "skill", "level", "outcome"]
            #expect(fields == expected.union(["weeklyGoal"]))
            #expect(sent["outcome"] as? String == "finished")
        }
    }

    @Test func aCookStoppedEarlyIsSentAsStoppedEarly() throws {
        #expect(try sent(savedCook(.stoppedEarly))["outcome"] as? String == "stoppedEarly")
    }

    @Test func eachCookCarriesTheZoneItWasCookedIn() throws {
        #expect(try sent(savedCook(), in: "America/New_York")["timeZone"] as? String == "America/New_York")
    }

    @Test func theIDIsWrittenInLowerCaseAsTheServerWritesIt() throws {
        #expect(try sent(savedCook())["id"] as? String == "4e2c2a0e-7e6b-4c7a-9c2b-6e0a3d1f9a11")
    }

    @Test func aMomentWithinASecondIsSentToTheSecond() throws {
        let cook = savedCook()
        let later = CookSession(date: cook.session.date.addingTimeInterval(0.25), result: .stoppedEarly, weeklyGoal: 3)
        let moved = CookEntry(id: cook.id, lesson: cook.lesson, session: later)
        #expect(try sent(moved)["cookedAt"] as? String == "2026-10-20T18:42:00Z")
    }

    /// The server takes no cook of a bundled lesson: it would refuse the dish. Such a cook has no payload, so it can
    /// never be sent by mistake.
    @Test func aCookOfABundledLessonHasNoPayload() {
        let lesson = CookedLesson(id: "eggs-scrambled-1", skill: "eggs", level: 1)
        let cook = CookEntry(id: UUID(), lesson: lesson, session: savedCook().session)
        #expect(CookEntryPayload(entry: cook, timeZone: .gmt) == nil)
        #expect(!cook.isSendable)
        #expect(savedCook().isSendable)
    }
}
