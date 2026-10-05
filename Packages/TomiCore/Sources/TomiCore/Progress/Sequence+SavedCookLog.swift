import Foundation

/// The cook log out of every cook record in the store, in any order, possibly merged from two devices.
extension Sequence where Element == SavedCookEntry {
    /// Every readable entry once, oldest first. The same records in another order give the same log.
    /// Saved data has no unique constraints, so a cook that arrived twice is two records with one id.
    public var cookLog: [CookEntry] {
        var seenIDs: Set<UUID> = []
        var log: [CookEntry] = []
        for entry in readableEntriesInLogOrder {
            let isFirstCopy = seenIDs.insert(entry.id).inserted
            if isFirstCopy {
                log.append(entry)
            }
        }
        return log
    }

    private var readableEntriesInLogOrder: [CookEntry] {
        var entries: [CookEntry] = []
        for record in self {
            if let entry = record.entry {
                entries.append(entry)
            }
        }
        return entries.sorted { $0.comesInLog(before: $1) }
    }
}
