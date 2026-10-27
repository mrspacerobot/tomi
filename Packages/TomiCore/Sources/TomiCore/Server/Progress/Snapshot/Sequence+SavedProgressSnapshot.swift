import Foundation

/// The last snapshot out of every snapshot record in the store, in any order.
extension Sequence where Element == SavedProgressSnapshot {
    /// The snapshot received last, read as the server sent it. Nil when there is none, when its body cannot be read
    /// or when two copies of the same moment disagree: the phone then asks the server again, and never shows zeros.
    public var lastSnapshot: ProgressSnapshot? {
        guard let newest, let body = newest.body else {
            return nil
        }
        return try? JSONDecoder().decode(ProgressSnapshot.self, from: body)
    }
}
