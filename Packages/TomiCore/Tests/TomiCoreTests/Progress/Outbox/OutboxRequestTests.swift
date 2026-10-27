import Foundation
import Testing

@testable import TomiCore

/// What one upload sends: the oldest pending cook, under the id it was saved with. The server takes one cook per
/// request, so the outbox is sent one cook after another.
@Suite struct OutboxRequestTests {
    let calendar = TestCalendar(timeZone: "Europe/Amsterdam", firstWeekday: 2).calendar

    func cooks(_ count: Int) -> [CookEntry] {
        (0..<count).map { CookEntry.fixture("knife", on: .october(1 + $0 % 28)) }
    }

    func request(of records: [SavedCookEntry]) -> CookEntryRequest? {
        records.nextOutboxRequest(for: CookEntry.fixtureAccount, calendar: calendar)
    }

    @Test func theRequestHoldsTheOldestCookOnly() {
        let records = cooks(5).map { SavedCookEntry($0) }
        #expect(request(of: records)?.entry.id == records.cookLog.first?.id)
    }

    @Test func theSameRecordsInAnyOrderGiveTheSameRequest() {
        let records = cooks(30).map { SavedCookEntry($0) }
        #expect(request(of: records) == request(of: records.shuffled()))
        #expect(request(of: records) == request(of: Array(records.reversed())))
    }

    @Test func aRequestCarriesTheCalendarPassedIn() {
        let request = request(of: cooks(1).map { SavedCookEntry($0) })
        #expect(request?.calendar == CalendarContext(timeZone: "Europe/Amsterdam", firstWeekday: 2))
        #expect(request?.entry.timeZone == "Europe/Amsterdam")
    }

    @Test func refusedCooksAreNeverSentAgain() {
        let log = cooks(3)
        var records = log.map { SavedCookEntry($0) }
        records[0].refusedCode = "cooked_in_future"
        let next = request(of: records)?.entry.id
        #expect(next != log[0].id)
        #expect(next == records.cookLog[1].id)
    }

    /// The id is the server's key for counting a cook once, so a cook is sent under the same id every time:
    /// when the first try failed, and when other cooks around it came and went.
    @Test func aCookKeepsItsIDInEveryRequestItIsSentIn() {
        let kept = CookEntry.fixture("eggs", on: .september(30))
        let alone = request(of: [SavedCookEntry(kept)])
        let amongOthers = request(of: ([kept] + cooks(40)).map { SavedCookEntry($0) }.shuffled())
        #expect(alone?.entry.id == kept.id)
        #expect(amongOthers?.entry.id == kept.id)
    }

    @Test func anEmptyOutboxGivesNoRequest() {
        #expect(request(of: []) == nil)
    }

    /// The server takes only graph recipes, so a cook of a bundled lesson is not sent and does not block the cooks
    /// after it.
    @Test func aCookOfABundledLessonIsSkippedAndTheNextOneIsSent() {
        let bundled = CookEntry.fixture("knife", on: .october(1)).ofABundledLesson()
        let recipe = CookEntry.fixture("eggs", on: .october(2))
        #expect(request(of: [SavedCookEntry(bundled), SavedCookEntry(recipe)])?.entry.id == recipe.id)
        #expect(request(of: [SavedCookEntry(bundled)]) == nil)
    }
}
