import Foundation
import Testing

@testable import TomiCore

/// The outbox is the cook log on the phone: every readable cook the server has not acknowledged or refused.
@Suite struct OutboxPendingTests {
    let monday = CookEntry.fixture("knife", on: .october(5))
    let tuesday = CookEntry.fixture("knife", on: .october(6))
    let wednesday = CookEntry.fixture("eggs", on: .october(7))

    @Test func everyReadableCookIsPending() {
        let records = [wednesday, monday, tuesday].map { SavedCookEntry($0) }
        #expect(records.pendingCookEntries == [monday, tuesday, wednesday])
    }

    @Test func aCookTheServerRefusedIsNotPending() {
        var refused = SavedCookEntry(tuesday)
        refused.refusedCode = "cooked_in_future"
        let records = [SavedCookEntry(monday), refused, SavedCookEntry(wednesday)]
        #expect(records.pendingCookEntries == [monday, wednesday])
    }

    @Test(arguments: RequiredCookField.allCases)
    func aRecordThatCannotBeReadIsNotPending(field: RequiredCookField) {
        let records = [SavedCookEntry(monday), SavedCookEntry(tuesday).without(field)]
        #expect(records.pendingCookEntries == [monday])
    }

    /// Saved data has no unique constraints, so one cook can lie in the store twice. Once any copy is refused,
    /// the cook is refused, whichever copy the store hands over first.
    @Test func aCookWithOneRefusedCopyIsNotPendingInAnyOrder() {
        var refused = SavedCookEntry(tuesday)
        refused.refusedCode = "invalid_time_zone"
        let records = [SavedCookEntry(tuesday), refused, SavedCookEntry(monday)]
        #expect(records.pendingCookEntries == [monday])
        #expect(Array(records.reversed()).pendingCookEntries == [monday])
    }

    @Test func aCookSavedTwiceIsPendingOnce() {
        let records = [monday, tuesday, monday].map { SavedCookEntry($0) }
        #expect(records.pendingCookEntries == [monday, tuesday])
    }

    @Test func theRefusedCodeIsKeptWhenARecordIsCopied() {
        var refused = SavedCookEntry(monday)
        refused.refusedCode = "level_out_of_range"
        var copy = SavedCookEntry()
        copy.refusedCode = refused.refusedCode
        #expect(copy.refusedCode == "level_out_of_range")
        #expect(SavedCookEntry(monday).refusedCode == nil)
    }
}
