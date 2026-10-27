import Foundation
import Testing

@testable import TomiCore

/// The progress snapshot is read exactly as the server sent it. Nothing missing is ever read as zero.
@Suite struct ProgressSnapshotTests {
    func snapshot(_ text: String = ProgressJSON.snapshot) throws -> ProgressSnapshot {
        try ServerJSON.decode(ProgressSnapshot.self, from: text)
    }

    @Test func theBackendExampleIsReadAsSent() throws {
        let snapshot = try snapshot()
        #expect(snapshot.schemaVersion.number == 1)
        #expect(snapshot.rulesVersion == 1)
        #expect(snapshot.catalogVersion == 1)
        #expect(snapshot.calendar == CalendarContext(timeZone: "Europe/Amsterdam", firstWeekday: 2))
        #expect(snapshot.xp == 350)
        #expect(snapshot.rank == SnapshotRank(id: "commis", name: "Commis", tier: 1, startsAt: 150, nextAt: 400))
        #expect(snapshot.masteredCount == 1)
        #expect(snapshot.focusSkill == "knife-cuts")
        #expect(snapshot.counted == SnapshotCounts(finishedCooks: 7, ignoredUnknownSkillOrLevel: 0))
    }

    @Test func theInstantsAreReadAsUTCInstants() throws {
        let snapshot = try snapshot()
        let utc = UTCMoment()
        #expect(snapshot.computedAt.date == utc.date(.october(27), hour: 18, minute: 43, second: 2))
        #expect(snapshot.streak.weekStartsAt.date == utc.date(.october(25), hour: 23))
        #expect(snapshot.streak.weekEndsAt.date == utc.date(.november(1), hour: 23))
    }

    @Test func theStreakIsReadAsSent() throws {
        let streak = try snapshot().streak
        #expect(streak.weeks == 2)
        #expect(streak.weeksBeforeThisWeek == 2)
        #expect(streak.daysThisWeek == 1)
        #expect(streak.goal == 3)
        #expect(streak.daysLeftInWeek == 6)
        #expect(!streak.thisWeekMet)
        #expect(!streak.atRisk)
        #expect(!streak.lost)
    }

    @Test func eachSkillIsReadWithItsLevelsInCatalogOrder() throws {
        let skills = try snapshot().skills
        let level = SnapshotLevel(number: 1, cooks: 2, cooksToComplete: 2, open: true, granted: false, complete: true)
        #expect(skills.prefix(2).map(\.skill) == ["knife-cuts", "eggs"])
        let eggs = skills[1]
        #expect(eggs.status == .mastered)
        #expect(eggs.missingPrerequisites == [])
        #expect(eggs.currentLevel == 3)
        #expect(eggs.levels.first == level)
        #expect(eggs.levels.map(\.number) == [1, 2, 3])
        #expect(skills[0].status == .served)
    }

    @Test func aSnapshotWithoutAFocusSkillHasNone() throws {
        let text = ProgressJSON.snapshot(setting: ["focusSkill"], to: NSNull())
        #expect(text != ProgressJSON.snapshot)
        #expect(try snapshot(text).focusSkill == nil)
    }

    @Test func aFieldAddedByANewerServerIsIgnored() throws {
        let text = ProgressJSON.snapshot(setting: ["sparkles"], to: 9)
        #expect(text != ProgressJSON.snapshot)
        #expect(try snapshot(text).xp == 350)
    }
}
