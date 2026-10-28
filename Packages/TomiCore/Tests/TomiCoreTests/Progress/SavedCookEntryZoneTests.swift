import Foundation
import Testing

@testable import TomiCore

/// The zone a cook was made in, to the store and back. The server judges each past week by every cook's own zone.
@Suite struct SavedCookEntryZoneTests {
    @Test func theZoneACookWasMadeInIsWrittenAndReadBack() {
        let cook = CookEntry.fixture("knife").cooked(in: "Asia/Tokyo")
        let saved = SavedCookEntry(cook)
        #expect(saved.timeZone == "Asia/Tokyo")
        #expect(saved.entry == cook)
        #expect(saved.entry?.session.timeZone == TimeZone(identifier: "Asia/Tokyo"))
    }

    /// Cooks saved before the zone was recorded are still cooks. Whoever sends them chooses the zone.
    @Test func aCookSavedWithoutAZoneIsReadWithoutOne() {
        let saved = SavedCookEntry(.fixture("knife"))
        #expect(saved.timeZone == nil)
        #expect(saved.entry != nil)
        #expect(saved.entry?.session.timeZone == nil)
    }

    @Test(arguments: ["Mars/Olympus_Mons", "", " "])
    func aZoneThisPhoneCannotReadIsReadAsNoZone(zone: String) {
        var saved = SavedCookEntry(.fixture("knife"))
        saved.timeZone = zone
        #expect(saved.entry != nil)
        #expect(saved.entry?.session.timeZone == nil)
    }

    @Test func aNewCookIsNotRefused() {
        #expect(SavedCookEntry(.fixture("knife")).refusedCode == nil)
    }
}
