import Foundation
import Testing
import TomiCore

@testable import Tomi

/// The cook log in the SwiftData store, including what iCloud can do to it: the same cook as two records.
@MainActor
@Suite struct StoredCookLogTests {
    let fixture: StoreFixture
    let cook = CookEntry.fixture("eggs", onOctober: 5)

    init() throws {
        fixture = try StoreFixture()
    }

    @Test func aCookAddedTwiceIsStoredOnce() throws {
        try fixture.store.add(cook)
        try fixture.store.add(cook)
        #expect(try fixture.count(of: CookLogRecord.self) == 1)
    }

    @Test func theSameCookArrivingAsTwoRecordsIsReadOnceAndEarnsOnce() throws {
        try fixture.insertCook(SavedCookEntry(cook))
        try fixture.insertCook(SavedCookEntry(cook))
        #expect(try fixture.count(of: CookLogRecord.self) == 2)
        #expect(try fixture.store.cookLog() == [cook])
        #expect(try fixture.store.cookLog().earnedXP == GameRules.xpForFinishedCook(quizCorrect: true))
    }

    @Test func aRecordThatCannotBeReadIsLeftOutAndKeptInTheStore() throws {
        var broken = SavedCookEntry(.fixture("eggs", onOctober: 6))
        broken.date = nil
        try fixture.insertCook(broken)
        try fixture.store.add(cook)
        #expect(try fixture.store.cookLog() == [cook])
        #expect(try fixture.count(of: CookLogRecord.self) == 2)
    }

    @Test func aCookOfASkillThisAppDoesNotKnowIsKept() throws {
        let fromNewerApp = CookEntry.fixture("a-skill-from-a-newer-app", onOctober: 5)
        try fixture.store.add(fromNewerApp)
        #expect(try fixture.store.cookLog() == [fromNewerApp])
    }

    @Test func aCookStoppedEarlyIsKeptAndEarnsNothing() throws {
        let session = CookSession(date: .october(5), result: .stoppedEarly, weeklyGoal: 3)
        let stopped = CookEntry(id: UUID(), lesson: cook.lesson, session: session, account: cook.account)
        try fixture.store.add(stopped)
        #expect(try fixture.store.cookLog() == [stopped])
        #expect(try fixture.store.cookLog().earnedXP == 0)
    }
}
