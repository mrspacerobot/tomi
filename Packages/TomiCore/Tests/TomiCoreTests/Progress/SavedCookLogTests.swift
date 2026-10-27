import Foundation
import Testing

@testable import TomiCore

/// The cook log read out of the store: every cook once, in one fixed order, whatever order the records come in.
@Suite struct SavedCookLogTests {
    let log = ProgressTestLog()
    let monday = CookEntry.fixture("knife", on: .october(5))
    let tuesday = CookEntry.fixture("knife", on: .october(6))
    let wednesday = CookEntry.fixture("eggs", on: .october(7))

    @Test func theLogIsReadOldestFirst() {
        let records = [wednesday, monday, tuesday].map { SavedCookEntry($0) }
        #expect(records.cookLog == [monday, tuesday, wednesday])
    }

    @Test func theSameCookSavedTwiceIsReadOnce() {
        let records = [monday, tuesday, monday].map { SavedCookEntry($0) }
        #expect(records.cookLog == [monday, tuesday])
    }

    @Test func twoStoresMergedInEitherOrderGiveTheSameLog() {
        let phone = [monday, tuesday].map { SavedCookEntry($0) }
        let tablet = [tuesday, wednesday].map { SavedCookEntry($0) }
        #expect((phone + tablet).cookLog == (tablet + phone).cookLog)
        #expect((phone + tablet).cookLog == [monday, tuesday, wednesday])
    }

    @Test func aRecordThatCannotBeReadIsLeftOutAndTheRestStillCounts() {
        let broken = SavedCookEntry(tuesday).without(.date)
        let records = [SavedCookEntry(monday), broken, SavedCookEntry(wednesday)]
        #expect(records.cookLog == [monday, wednesday])
    }

    @Test func cooksOfTheSameMomentComeInOneFixedOrder() {
        let first = CookEntry.fixture("knife")
        let second = CookEntry.fixture("eggs")
        let records = [first, second].map { SavedCookEntry($0) }
        #expect(records.cookLog == Array(records.reversed()).cookLog)
        #expect(records.cookLog.count == 2)
    }

    /// A log written once never holds two copies that disagree. If it ever does, the same copy must always win.
    @Test func copiesOfOneCookThatDisagreeAlwaysGiveTheSameEntry() {
        let finished = SavedCookEntry(monday)
        let stopped = SavedCookEntry(monday.stoppedBeforeTheEnd())
        let wrong = SavedCookEntry(monday.withTheQuizWrong())
        #expect([finished, stopped].cookLog == [stopped, finished].cookLog)
        #expect([finished, stopped].cookLog == [monday.stoppedBeforeTheEnd()])
        #expect([finished, wrong].cookLog == [wrong, finished].cookLog)
        #expect([finished, wrong].cookLog == [monday.withTheQuizWrong()])
    }

    @Test func copiesOfOneCookThatDisagreeOnlyInTheirZoneAlwaysGiveTheSameEntry() {
        let tokyo = SavedCookEntry(monday.cooked(in: "Asia/Tokyo"))
        let lima = SavedCookEntry(monday.cooked(in: "America/Lima"))
        let unzoned = SavedCookEntry(monday)
        #expect([tokyo, lima].cookLog == [lima, tokyo].cookLog)
        #expect([tokyo, lima].cookLog == [monday.cooked(in: "America/Lima")])
        #expect([tokyo, unzoned].cookLog == [unzoned, tokyo].cookLog)
        #expect([tokyo, unzoned].cookLog == [monday])
    }

    @Test func progressAndXPFromTheStoredLogMatchTheLogItWasSavedFrom() {
        let entries = log.cooks(2, of: "knife") + [CookEntry.fixture("eggs").stoppedBeforeTheEnd()]
        let records = (entries + entries).map { SavedCookEntry($0) }
        #expect(log.progress(records.cookLog) == log.progress(entries))
        #expect(records.cookLog.earnedXP == entries.earnedXP)
    }

    @Test func aCookOfASkillTheMenuLacksStillEarnsAndNeverBreaksProgress() {
        let records = [SavedCookEntry(.fixture("sous-vide"))]
        #expect(records.cookLog.earnedXP == GameRules.xpForFinishedCook(quizCorrect: true))
        #expect(log.progress(records.cookLog) == log.progress([]))
    }
}
