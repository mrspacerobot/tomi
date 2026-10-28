/// The body of `POST /v1/cook-entries`: the cook's calendar now, and one cook entry. The server takes one cook per
/// request and answers for that cook alone.
public struct CookEntryRequest: Hashable, Codable, Sendable {
    public let calendar: CalendarContext
    public let entry: CookEntryPayload

    public init(calendar: CalendarContext, entry: CookEntryPayload) {
        self.calendar = calendar
        self.entry = entry
    }
}
