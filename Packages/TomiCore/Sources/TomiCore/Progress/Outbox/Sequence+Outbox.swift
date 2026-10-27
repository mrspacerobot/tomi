import Foundation

/// The outbox out of every cook record in the store, in any order, possibly holding copies of one cook.
extension Sequence where Element == SavedCookEntry {
    /// Every readable cook the server has not refused, each once, oldest first, in the cook log's fixed order.
    /// A cook is refused when any copy of it is, so the answer never depends on which copy comes first.
    public var pendingCookEntries: [CookEntry] {
        let refused = refusedIDs
        return cookLog.filter { !refused.contains($0.id) }
    }

    /// The pending cooks this account made that the server could take. A cook of another account, or of none, or
    /// of no graph recipe, stays on the phone untouched.
    public func pendingCookEntries(for account: String) -> [CookEntry] {
        pendingCookEntries.filter { $0.account == account && $0.isSendable }
    }

    /// The next request to send: the oldest cook this account made. The same records in any order give the same
    /// request.
    public func nextOutboxRequest(for account: String, calendar: Calendar) -> CookEntryRequest? {
        pendingCookEntries(for: account).nextOutboxRequest(calendar: calendar)
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
