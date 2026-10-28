import Foundation
import Testing

@testable import TomiCore

/// The calendar sent with every progress call comes from the calendar passed in, never the phone's own.
@Suite struct CalendarContextTests {
    func calendar(_ timeZone: String, firstWeekday: Int) -> Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: timeZone)!
        calendar.firstWeekday = firstWeekday
        return calendar
    }

    @Test func theZoneAndFirstWeekdayComeFromTheCalendarPassedIn() {
        let amsterdam = CalendarContext(calendar: calendar("Europe/Amsterdam", firstWeekday: 2))
        let newYork = CalendarContext(calendar: calendar("America/New_York", firstWeekday: 1))
        #expect(amsterdam == CalendarContext(timeZone: "Europe/Amsterdam", firstWeekday: 2))
        #expect(newYork == CalendarContext(timeZone: "America/New_York", firstWeekday: 1))
    }

    @Test func itIsSentUnderTheServersNames() throws {
        let context = CalendarContext(calendar: calendar("Asia/Tokyo", firstWeekday: 1))
        let sent = try ProgressJSON.object(of: JSONEncoder().encode(context))
        #expect(sent == ["timeZone": "Asia/Tokyo", "firstWeekday": 1])
    }

    @Test func aFirstWeekdayOutsideSundayToSaturdayIsRefused() {
        #expect(throws: (any Error).self) {
            try ServerJSON.decode(CalendarContext.self, from: #"{"timeZone": "Asia/Tokyo", "firstWeekday": 8}"#)
        }
    }

    @Test func aBlankZoneIsRefused() {
        #expect(throws: (any Error).self) {
            try ServerJSON.decode(CalendarContext.self, from: #"{"timeZone": " ", "firstWeekday": 2}"#)
        }
    }
}
