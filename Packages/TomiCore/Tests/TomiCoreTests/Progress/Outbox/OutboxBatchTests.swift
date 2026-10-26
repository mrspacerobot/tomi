import Foundation
import Testing

@testable import TomiCore

/// What one upload sends: at most a hundred pending cooks, oldest first, each under the id it was saved with.
@Suite struct OutboxBatchTests {
    let calendar = StreakTestCalendar(timeZone: "Europe/Amsterdam", firstWeekday: 2).calendar

    func cooks(_ count: Int) -> [CookEntry] {
        (0..<count).map { CookEntry.fixture("knife", on: .october(1 + $0 % 28)) }
    }

    @Test func aBatchHoldsAtMostAHundredCooksOldestFirst() {
        let records = cooks(130).map { SavedCookEntry($0) }
        let oldestHundred = records.cookLog.prefix(100).map(\.id)
        #expect(CookOutbox.largestBatch == 100)
        #expect(records.outboxBatch(calendar: calendar).entries.map(\.id) == oldestHundred)
    }

    @Test func theSameRecordsInAnyOrderGiveTheSameBatch() {
        let records = cooks(130).map { SavedCookEntry($0) }
        let shuffled = records.shuffled()
        #expect(records.outboxBatch(calendar: calendar) == shuffled.outboxBatch(calendar: calendar))
        #expect(records.outboxBatch(calendar: calendar) == Array(records.reversed()).outboxBatch(calendar: calendar))
    }

    @Test func aBatchCarriesTheCalendarPassedIn() {
        let batch = cooks(1).map { SavedCookEntry($0) }.outboxBatch(calendar: calendar)
        #expect(batch.calendar == CalendarContext(timeZone: "Europe/Amsterdam", firstWeekday: 2))
        #expect(batch.entries.map(\.timeZone) == ["Europe/Amsterdam"])
    }

    @Test func refusedCooksAreNeverSentAgain() {
        let log = cooks(3)
        var records = log.map { SavedCookEntry($0) }
        records[1].refusedCode = "cooked_in_future"
        let sent = records.outboxBatch(calendar: calendar).entries.map(\.id)
        #expect(sent.count == 2)
        #expect(!sent.contains(log[1].id))
    }

    /// The id is the server's key for counting a cook once, so a cook is sent under the same id every time:
    /// when the first try failed, and when other cooks around it came and went.
    @Test func aCookKeepsItsIDInEveryBatchItIsSentIn() {
        let kept = CookEntry.fixture("eggs", on: .september(30))
        let first = ([kept] + cooks(2)).map { SavedCookEntry($0) }.outboxBatch(calendar: calendar)
        let retried = ([kept] + cooks(150)).map { SavedCookEntry($0) }.shuffled().outboxBatch(calendar: calendar)
        let later = [SavedCookEntry(kept)].outboxBatch(calendar: calendar)
        #expect(first.entries.contains { $0.id == kept.id })
        #expect(retried.entries.contains { $0.id == kept.id })
        #expect(later.entries.map(\.id) == [kept.id])
    }

    @Test func anEmptyOutboxGivesAnEmptyBatch() {
        #expect([SavedCookEntry]().outboxBatch(calendar: calendar).entries.isEmpty)
    }
}
