import Foundation
import Testing

@testable import TomiCore

/// Each cook is sent with the zone it was cooked in, so the server counts it on the day it was cooked there,
/// even when the cook has travelled before the phone is back online.
@Suite struct OutboxTimeZoneTests {
    let home = TestCalendar(timeZone: "Europe/Amsterdam", firstWeekday: 2).calendar

    func request(_ cooks: [CookEntry]) -> CookEntryRequest? {
        cooks.map { SavedCookEntry($0) }.nextOutboxRequest(for: CookEntry.fixtureAccount, calendar: home)
    }

    @Test func aCookIsSentWithTheZoneItWasCookedInNotTheZoneOfTheUpload() {
        let tokyo = CookEntry.fixture("knife").cooked(in: "Asia/Tokyo")
        let request = request([tokyo])
        #expect(request?.entry.timeZone == "Asia/Tokyo")
        #expect(request?.calendar == CalendarContext(timeZone: "Europe/Amsterdam", firstWeekday: 2))
    }

    @Test func eachCookKeepsItsOwnZoneInTheRequestOfItsTurn() {
        let tokyo = CookEntry.fixture("knife", on: .october(5)).cooked(in: "Asia/Tokyo")
        let newYork = CookEntry.fixture("eggs", on: .october(6)).cooked(in: "America/New_York")
        #expect(request([newYork, tokyo])?.entry.timeZone == "Asia/Tokyo")
        #expect(request([newYork])?.entry.timeZone == "America/New_York")
    }

    /// Cooks saved before the zone was recorded have none. They are sent with the zone of the calendar passed in.
    @Test func aCookSavedBeforeZonesWereRecordedIsSentWithTheCalendarsZone() {
        #expect(request([CookEntry.fixture("knife", on: .october(5))])?.entry.timeZone == "Europe/Amsterdam")
    }

    @Test func aZoneThisPhoneCannotReadIsSentWithTheCalendarsZone() {
        var saved = SavedCookEntry(.fixture("knife"))
        saved.timeZone = "Mars/Olympus_Mons"
        let request = [saved].nextOutboxRequest(for: CookEntry.fixtureAccount, calendar: home)
        #expect(request?.entry.timeZone == "Europe/Amsterdam")
    }

    @Test func theCooksOfTheLogGiveTheSameRequestAsTheirRecords() {
        let cooks = [
            CookEntry.fixture("knife", on: .october(5)).cooked(in: "Asia/Tokyo"),
            CookEntry.fixture("eggs", on: .october(6)),
        ]
        let records = cooks.map { SavedCookEntry($0) }
        let fromLog = records.pendingCookEntries.nextOutboxRequest(calendar: home)
        #expect(fromLog == records.nextOutboxRequest(for: CookEntry.fixtureAccount, calendar: home))
    }
}
