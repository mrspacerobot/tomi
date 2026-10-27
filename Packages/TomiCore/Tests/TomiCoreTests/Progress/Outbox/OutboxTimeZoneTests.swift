import Foundation
import Testing

@testable import TomiCore

/// Each cook is sent with the zone it was cooked in, so the server counts it on the day it was cooked there,
/// even when the cook has travelled before the phone is back online.
@Suite struct OutboxTimeZoneTests {
    let home = TestCalendar(timeZone: "Europe/Amsterdam", firstWeekday: 2).calendar

    @Test func aCookIsSentWithTheZoneItWasCookedInNotTheZoneOfTheUpload() {
        let tokyo = CookEntry.fixture("knife").cooked(in: "Asia/Tokyo")
        let batch = [SavedCookEntry(tokyo)].outboxBatch(for: CookEntry.fixtureAccount, calendar: home)
        #expect(batch.entries.map(\.timeZone) == ["Asia/Tokyo"])
        #expect(batch.calendar == CalendarContext(timeZone: "Europe/Amsterdam", firstWeekday: 2))
    }

    @Test func cooksFromSeveralZonesKeepTheirOwnZoneInOneBatch() {
        let tokyo = CookEntry.fixture("knife", on: .october(5)).cooked(in: "Asia/Tokyo")
        let newYork = CookEntry.fixture("eggs", on: .october(6)).cooked(in: "America/New_York")
        let batch = [newYork, tokyo].map { SavedCookEntry($0) }.outboxBatch(
            for: CookEntry.fixtureAccount,
            calendar: home
        )
        #expect(batch.entries.map(\.timeZone) == ["Asia/Tokyo", "America/New_York"])
    }

    /// Cooks saved before the zone was recorded have none. They are sent with the zone of the calendar passed in.
    @Test func aCookSavedBeforeZonesWereRecordedIsSentWithTheCalendarsZone() {
        let older = CookEntry.fixture("knife", on: .october(5))
        let newer = CookEntry.fixture("eggs", on: .october(6)).cooked(in: "Asia/Tokyo")
        let batch = [older, newer].map { SavedCookEntry($0) }.outboxBatch(for: CookEntry.fixtureAccount, calendar: home)
        #expect(batch.entries.map(\.timeZone) == ["Europe/Amsterdam", "Asia/Tokyo"])
    }

    @Test func aZoneThisPhoneCannotReadIsSentWithTheCalendarsZone() {
        var saved = SavedCookEntry(.fixture("knife"))
        saved.timeZone = "Mars/Olympus_Mons"
        #expect(
            [saved].outboxBatch(for: CookEntry.fixtureAccount, calendar: home).entries.map(\.timeZone) == [
                "Europe/Amsterdam"
            ]
        )
    }

    @Test func theCooksOfTheLogBatchTheSameAsTheirRecords() {
        let cooks = [
            CookEntry.fixture("knife", on: .october(5)).cooked(in: "Asia/Tokyo"),
            CookEntry.fixture("eggs", on: .october(6)),
        ]
        let records = cooks.map { SavedCookEntry($0) }
        #expect(
            records.pendingCookEntries.outboxBatch(calendar: home)
                == records.outboxBatch(for: CookEntry.fixtureAccount, calendar: home)
        )
    }
}
