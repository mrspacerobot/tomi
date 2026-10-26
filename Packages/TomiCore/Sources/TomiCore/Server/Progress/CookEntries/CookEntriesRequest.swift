/// The body of `POST /v1/cook-entries`: the cook's calendar now, and the cook entries of one batch.
public struct CookEntriesRequest: Hashable, Codable, Sendable {
    public let calendar: CalendarContext
    public let entries: [CookEntryPayload]

    public init(calendar: CalendarContext, entries: [CookEntryPayload]) {
        self.calendar = calendar
        self.entries = entries
    }
}
