import Foundation

extension Sequence where Element == SavedCookEntry {
    /// Conflicting owners make a cook untrustworthy, including a copy with no known owner.
    var conflictingAccountIDs: Set<UUID> {
        var owners: [UUID: Set<String?>] = [:]
        for record in self {
            if let id = record.stableID {
                owners[id, default: []].insert(record.account)
            }
        }
        return Set(owners.filter { $0.value.count > 1 }.map(\.key))
    }
}
