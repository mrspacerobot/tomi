import Foundation
import Testing

@testable import TomiCore

/// The cook log read out of the store: every cook once, in one fixed order, whatever order the records come in.
@Suite struct SavedCookLogTests {
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

    /// The zone only breaks a tie. A finished copy in Lima must not beat a copy stopped early in Tokyo, whatever
    /// the order of the zones, because the copy that earns least is the one kept.
    @Test func theZoneNeverOutranksHowTheCookEnded() {
        let monday = CookEntry.fixture("knife", on: .october(5))
        let finished = SavedCookEntry(monday.cooked(in: "America/Lima"))
        let stopped = SavedCookEntry(monday.stoppedBeforeTheEnd().cooked(in: "Asia/Tokyo"))
        let kept = [finished, stopped].cookLog
        #expect(kept == [monday.stoppedBeforeTheEnd().cooked(in: "Asia/Tokyo")])
        #expect([stopped, finished].cookLog == kept)
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

    @Test func theStoredLogHoldsEveryCookItWasSavedFromOnceStoppedCooksIncluded() {
        let stopped = CookEntry.fixture("eggs", on: .october(7)).stoppedBeforeTheEnd()
        let entries = [monday, tuesday, stopped]
        let records = (entries + entries).map { SavedCookEntry($0) }
        #expect(records.cookLog == entries)
    }

    /// The menu plays no part in reading the store: what the server makes of a skill is its own business.
    @Test func aCookOfASkillTheMenuLacksIsStillRead() {
        let unknown = CookEntry.fixture("sous-vide")
        #expect([SavedCookEntry(unknown)].cookLog == [unknown])
    }
}
