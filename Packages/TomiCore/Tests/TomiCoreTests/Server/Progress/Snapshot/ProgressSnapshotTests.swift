import Foundation
import Testing

@testable import TomiCore

/// The progress snapshot is read exactly as the server sent it. Nothing missing is ever read as zero.
@Suite struct ProgressSnapshotTests {
    @Test func theBackendExampleIsReadAsSent() throws {
        let snapshot = try ServerJSON.decode(ProgressSnapshot.self, from: ProgressJSON.snapshot)
        #expect(snapshot.schemaVersion.number == 1)
        #expect(snapshot.rulesVersion == 1)
        #expect(snapshot.catalogVersion == 1)
        #expect(snapshot.calendar == CalendarContext(timeZone: "Europe/Amsterdam", firstWeekday: 2))
        #expect(snapshot.xp == 360)
        #expect(snapshot.rank == SnapshotRank(id: "commis", name: "Commis", tier: 1, startsAt: 150, nextAt: 400))
        #expect(snapshot.masteredCount == 4)
        #expect(snapshot.focusSkill == "roux")
        #expect(snapshot.counted == SnapshotCounts(finishedCooks: 6, ignoredUnknownSkillOrLevel: 0))
    }

    @Test func theInstantsAreReadAsUTCInstants() throws {
        let snapshot = try ServerJSON.decode(ProgressSnapshot.self, from: ProgressJSON.snapshot)
        let utc = UTCMoment()
        #expect(snapshot.computedAt.date == utc.date(.october(26), hour: 18, minute: 43, second: 2))
        #expect(snapshot.streak.weekStartsAt.date == utc.date(.october(25), hour: 23))
        #expect(snapshot.streak.weekEndsAt.date == utc.date(.november(1), hour: 23))
    }

    @Test func theStreakIsReadAsSent() throws {
        let streak = try ServerJSON.decode(ProgressSnapshot.self, from: ProgressJSON.snapshot).streak
        #expect(streak.weeks == 2)
        #expect(streak.weeksBeforeThisWeek == 2)
        #expect(streak.daysThisWeek == 1)
        #expect(streak.goal == 3)
        #expect(streak.daysLeftInWeek == 4)
        #expect(!streak.thisWeekMet)
        #expect(!streak.atRisk)
        #expect(!streak.lost)
    }

    @Test func eachSkillIsReadWithItsLevels() throws {
        let skills = try ServerJSON.decode(ProgressSnapshot.self, from: ProgressJSON.snapshot).skills
        let level = SnapshotLevel(number: 1, cooks: 2, cooksToComplete: 2, open: true, granted: false, complete: true)
        #expect(skills.map(\.skill) == ["eggs"])
        #expect(skills.first?.status == .mastered)
        #expect(skills.first?.missingPrerequisites == [])
        #expect(skills.first?.currentLevel == 2)
        #expect(skills.first?.levels.first == level)
        #expect(skills.first?.levels.map(\.number) == [1, 2])
    }

    @Test func aSnapshotWithoutAFocusSkillHasNone() throws {
        let text = ProgressJSON.snapshot(replacing: #""focusSkill": "roux""#, with: #""focusSkill": null"#)
        #expect(text != ProgressJSON.snapshot)
        #expect(try ServerJSON.decode(ProgressSnapshot.self, from: text).focusSkill == nil)
    }

    @Test func aFieldAddedByANewerServerIsIgnored() throws {
        let text = ProgressJSON.snapshot(replacing: #""xp": 360,"#, with: #""xp": 360, "sparkles": 9,"#)
        #expect(text != ProgressJSON.snapshot)
        #expect(try ServerJSON.decode(ProgressSnapshot.self, from: text).xp == 360)
    }
}
