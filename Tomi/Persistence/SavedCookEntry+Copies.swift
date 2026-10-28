import Foundation
import TomiCore

extension SavedCookEntry {
    /// Whether this record is a copy of one of these cooks. A record without an id is a copy of none.
    func isCopy(ofOneOf ids: Set<UUID>) -> Bool {
        guard let stableID else {
            return false
        }
        return ids.contains(stableID)
    }
}
