import Foundation

/// A fixed calendar and dates for tests, so they never depend on the machine's clock, zone or locale.
struct TestCalendar {
    let calendar: Calendar

    init(timeZone: String = "UTC", firstWeekday: Int = 2) {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: timeZone)!
        calendar.firstWeekday = firstWeekday
        self.calendar = calendar
    }

    /// A moment on a day such as `.october(5)`, at 6 pm unless another hour is given.
    func date(_ day: DateComponents, hour: Int = 18) -> Date {
        var moment = day
        moment.hour = hour
        return calendar.date(from: moment)!
    }
}
