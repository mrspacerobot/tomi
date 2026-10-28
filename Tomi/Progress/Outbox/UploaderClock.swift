import Foundation

/// Where the uploader reads the time and waits: the phone's own in the app, fixed in tests.
struct UploaderClock {
    /// The moment an answer arrives, kept with the snapshot it carries.
    let now: () -> Date
    /// The cook's calendar at the moment of an upload, which the server judges the week in progress by.
    let calendar: () -> Calendar
    /// Waits out the backoff between tries.
    let sleeper: any Sleeper

    /// The phone's own clock, calendar and timer.
    static var phone: UploaderClock {
        UploaderClock(now: { Date.now }, calendar: { Calendar.current }, sleeper: TaskSleeper())
    }
}
