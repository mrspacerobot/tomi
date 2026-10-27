import Foundation

/// The batch out of the pending cooks, already in the cook log's order, as the store hands them over.
extension Array where Element == CookEntry {
    /// The oldest cooks, at most `CookOutbox.largestBatch`, each under the id it was saved with and in the zone it
    /// was cooked in, and the calendar passed in for the week in progress.
    public func outboxBatch(calendar: Calendar) -> CookEntriesRequest {
        let oldest = prefix(CookOutbox.largestBatch)
        let entries = oldest.map { CookEntryPayload(entry: $0, timeZone: $0.zone(orElse: calendar.timeZone)) }
        return CookEntriesRequest(calendar: CalendarContext(calendar: calendar), entries: entries)
    }
}
