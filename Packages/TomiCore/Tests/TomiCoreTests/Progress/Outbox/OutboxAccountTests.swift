import Foundation
import Testing

@testable import TomiCore

/// A cook is sent only with the credentials of the account that made it. When another cook signs in on the same
/// phone, the first cook's unsent cooks stay on the phone and wait for their own account.
@Suite struct OutboxAccountTests {
    let calendar = TestCalendar(timeZone: "Europe/Amsterdam", firstWeekday: 2).calendar
    let first = CookEntry.fixture("knife", on: .october(5)).cooked(by: "cook-a")
    let second = CookEntry.fixture("eggs", on: .october(6)).cooked(by: "cook-b")

    func saved(_ entries: [CookEntry]) -> [SavedCookEntry] {
        entries.map { SavedCookEntry($0) }
    }

    @Test func anAccountSendsOnlyItsOwnCooks() {
        let records = saved([first, second])
        #expect(records.pendingCookEntries(for: "cook-a") == [first])
        #expect(records.pendingCookEntries(for: "cook-b") == [second])
    }

    @Test func theRequestOfAnAccountIsForItsOwnCookOnly() {
        let request = saved([first, second]).nextOutboxRequest(for: "cook-b", calendar: calendar)
        #expect(request?.entry.id == second.id)
    }

    @Test func aCookWithoutAnAccountIsSentByNoAccount() {
        let anonymous = CookEntry.fixture("knife").cooked(by: nil)
        let records = saved([anonymous])
        #expect(records.pendingCookEntries(for: "cook-a").isEmpty)
        #expect(records.pendingCookEntries == [anonymous])
    }

    @Test func anAccountWithNoCooksSendsNothing() {
        #expect(saved([first]).nextOutboxRequest(for: "cook-c", calendar: calendar) == nil)
    }

    @Test func theAccountIsKeptWhenACookIsSavedAndRead() {
        let record = SavedCookEntry(first)
        #expect(record.account == "cook-a")
        #expect(record.entry?.account == "cook-a")
    }

    @Test func aCookSavedBeforeTheAccountWasRecordedIsReadWithoutOne() {
        var record = SavedCookEntry(first)
        record.account = nil
        #expect(record.entry?.account == nil)
    }

    @Test func aRefusedCookStaysRefusedForItsAccount() {
        var refused = SavedCookEntry(first)
        refused.refusedCode = "invalid_entry"
        #expect([refused].pendingCookEntries(for: "cook-a").isEmpty)
    }

    @Test func theGraphVersionIsKeptWhenACookIsSavedAndRead() {
        let record = SavedCookEntry(first)
        #expect(record.graphVersion == "2026.10.20")
        #expect(record.entry == first)
    }

    @Test func conflictingGraphVersionsProduceTheSameOutboxInEitherOrder() {
        var older = SavedCookEntry(first)
        older.graphVersion = nil
        let newer = SavedCookEntry(first)
        let records = [older, newer]
        let forward = records.pendingCookEntries(for: "cook-a")
        let backward = Array(records.reversed()).pendingCookEntries(for: "cook-a")
        #expect(forward == backward)
    }

    @Test func twoGraphVersionsProduceTheSameRequestInEitherOrder() {
        var other = SavedCookEntry(first)
        other.graphVersion = "another-version"
        let records = [SavedCookEntry(first), other]
        let forward = records.nextOutboxRequest(for: "cook-a", calendar: calendar)
        let backward = Array(records.reversed()).nextOutboxRequest(for: "cook-a", calendar: calendar)
        #expect(forward?.entry == backward?.entry)
    }

    @Test func conflictingAccountCopiesAreNeverSentByEitherAccount() {
        let records = [SavedCookEntry(first), SavedCookEntry(first.cooked(by: "cook-b"))]
        for copies in [records, Array(records.reversed())] {
            #expect(copies.pendingCookEntries(for: "cook-a").isEmpty)
            #expect(copies.pendingCookEntries(for: "cook-b").isEmpty)
        }
    }

    /// The server takes only graph recipes. A cook of a bundled lesson is kept and never counted as waiting.
    @Test func aCookOfABundledLessonIsKeptAndPendingForNoAccount() {
        let bundled = first.ofABundledLesson()
        let records = saved([bundled])
        #expect(records.cookLog == [bundled])
        #expect(records.pendingCookEntries(for: "cook-a").isEmpty)
        #expect(records.nextOutboxRequest(for: "cook-a", calendar: calendar) == nil)
    }
}
