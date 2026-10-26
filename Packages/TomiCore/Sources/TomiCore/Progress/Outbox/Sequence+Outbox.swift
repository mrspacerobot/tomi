import Foundation

/// The outbox out of every cook record in the store, in any order, possibly holding copies of one cook.
extension Sequence where Element == SavedCookEntry {
    /// Every readable cook the server has not refused, each once, oldest first, in the cook log's fixed order.
    /// A cook is refused when any copy of it is, so the answer never depends on which copy comes first.
    public var pendingCookEntries: [CookEntry] {
        let refused = refusedIDs
        return cookLog.filter { !refused.contains($0.id) }
    }

    /// The next batch to send: the oldest pending cooks, at most `CookOutbox.largestBatch`, each under the id it
    /// was saved with, and the calendar passed in. The same records in any order give the same batch.
    public func outboxBatch(calendar: Calendar) -> CookEntriesRequest {
        let oldest = pendingCookEntries.prefix(CookOutbox.largestBatch)
        let entries = oldest.map { CookEntryPayload(entry: $0, timeZone: calendar.timeZone) }
        return CookEntriesRequest(calendar: CalendarContext(calendar: calendar), entries: entries)
    }

    private var refusedIDs: Set<UUID> {
        var ids: Set<UUID> = []
        for record in self where record.refusedCode != nil {
            if let id = record.stableID {
                ids.insert(id)
            }
        }
        return ids
    }
}
