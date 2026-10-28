import Foundation

/// The cook's calendar as the progress routes take it: an IANA time zone and the first day of the week,
/// 1 (Sunday) to 7 (Saturday) as Foundation numbers them. The server judges the week in progress by it.
public struct CalendarContext: Hashable, Codable, Sendable {
    public static let weekdays = 1...7

    public let timeZone: String
    public let firstWeekday: Int

    public init(timeZone: String, firstWeekday: Int) {
        self.timeZone = timeZone
        self.firstWeekday = firstWeekday
    }

    /// From the calendar the caller passes in, so no rule here ever reads the phone's own calendar.
    public init(calendar: Calendar) {
        self.init(timeZone: calendar.timeZone.identifier, firstWeekday: calendar.firstWeekday)
    }

    enum CodingKeys: String, CodingKey {
        case timeZone, firstWeekday
    }

    public init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        timeZone = try values.decode(String.self, forKey: .timeZone)
        firstWeekday = try values.decode(Int.self, forKey: .firstWeekday)
        guard !timeZone.isBlank, Self.weekdays.contains(firstWeekday) else {
            throw DecodingError.dataCorruptedError(forKey: .timeZone, in: values, debugDescription: "Bad calendar.")
        }
    }
}
