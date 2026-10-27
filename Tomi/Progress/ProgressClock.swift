import Foundation

/// Where Home's progress reads the time: the phone's own in the app, fixed in tests.
struct ProgressClock {
    /// The moment a snapshot arrives, and the moment its week is compared with.
    let now: () -> Date
    /// The cook's calendar, which the server judges the week in progress by.
    let calendar: () -> Calendar

    /// The phone's own clock and calendar.
    static var phone: ProgressClock {
        ProgressClock(now: { Date.now }, calendar: { Calendar.current })
    }
}
