import Foundation

/// Instants as the server writes them, in UTC, built from numbers instead of parsed from text.
struct UTCMoment {
    let calendar: Calendar

    init() {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "UTC")!
        self.calendar = calendar
    }

    func date(_ day: DateComponents, hour: Int, minute: Int = 0, second: Int = 0) -> Date {
        var moment = day
        moment.hour = hour
        moment.minute = minute
        moment.second = second
        return calendar.date(from: moment)!
    }
}
