import Foundation

/// The outbox out of every cook record in the store, in any order, possibly holding copies of one cook.
extension Sequence where Element == SavedCookEntry {
    /// Every readable cook the server has not refused, each once, oldest first, in the cook log's fixed order.
    /// A cook is refused when any copy of it is, so the answer never depends on which copy comes first.
    public var pendingCookEntries: [CookEntry] {
        let refused = refusedIDs
        return cookLog.filter { !refused.contains($0.id) }
    }

    /// The next batch to send out of the pending cooks. The same records in any order give the same batch.
    public func outboxBatch(calendar: Calendar) -> CookEntriesRequest {
        pendingCookEntries.outboxBatch(calendar: calendar)
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
