import Foundation

/// The last snapshot out of every snapshot record in the store, in any order.
extension Sequence where Element == SavedProgressSnapshot {
    /// A snapshot without an owner is never shown as an account's progress.
    public func lastSnapshot(for account: String) -> ProgressSnapshot? {
        filter { $0.account == account }.lastSnapshot
    }
    /// The snapshot received last, read as the server sent it. Nil when there is none, when its body cannot be read
    /// or when two copies of the same moment disagree: the phone then asks the server again, and never shows zeros.
    public var lastSnapshot: ProgressSnapshot? {
        guard let newest, let body = newest.body else {
            return nil
        }
        return try? JSONDecoder().decode(ProgressSnapshot.self, from: body)
    }
}
