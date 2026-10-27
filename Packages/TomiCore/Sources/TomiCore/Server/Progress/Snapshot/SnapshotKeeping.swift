import Foundation

/// Which snapshot the phone keeps when two arrive. A read of the progress and the answer to an upload can cross on
/// the way, so the one that arrives last is not always the one computed last. The server stamps each with the
/// moment it computed it, and an older one never replaces a newer one.
public enum SnapshotKeeping {
    /// True when this body is a snapshot the app can read and no older than the one kept. A snapshot computed at the
    /// same moment is kept again, so a repeated answer changes nothing. A body that cannot be read is never kept:
    /// it would replace a snapshot that can be shown with one that cannot.
    public static func shouldKeep(_ body: Data, over current: ProgressSnapshot?) -> Bool {
        guard let arriving = try? JSONDecoder().decode(ProgressSnapshot.self, from: body) else {
            return false
        }
        guard let current else {
            return true
        }
        return arriving.computedAt.date >= current.computedAt.date
    }
}
