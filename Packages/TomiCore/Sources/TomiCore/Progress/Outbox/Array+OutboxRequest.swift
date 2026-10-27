import Foundation

/// The next request out of the pending cooks, already in the cook log's order, as the store hands them over.
extension Array where Element == CookEntry {
    /// The oldest cook, under the id it was saved with and in the zone it was cooked in, and the calendar passed in
    /// for the week in progress. Nil when no cook can be sent.
    public func nextOutboxRequest(calendar: Calendar) -> CookEntryRequest? {
        guard let oldest = first else {
            return nil
        }
        let zone = oldest.zone(orElse: calendar.timeZone)
        guard let entry = CookEntryPayload(entry: oldest, timeZone: zone) else {
            return nil
        }
        return CookEntryRequest(calendar: CalendarContext(calendar: calendar), entry: entry)
    }
}
