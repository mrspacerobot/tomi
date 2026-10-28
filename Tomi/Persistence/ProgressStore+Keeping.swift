import Foundation
import TomiCore

extension ProgressStore {
    /// Keeps the snapshot as it arrived, unless it is older than the one kept (`SnapshotKeeping`). Reading and
    /// writing happen with nothing awaited between them, so two answers cannot both pass the check first.
    /// True when the snapshot was kept.
    @discardableResult
    func keepProgressSnapshot(_ body: Data, at moment: Date) throws -> Bool {
        guard SnapshotKeeping.shouldKeep(body, over: try progressSnapshot()) else {
            return false
        }
        try saveProgressSnapshot(body, at: moment)
        return true
    }

    @discardableResult
    func keepProgressSnapshot(_ body: Data, at moment: Date, for account: String) throws -> Bool {
        guard SnapshotKeeping.shouldKeep(body, over: try progressSnapshot(for: account)) else {
            return false
        }
        try saveProgressSnapshot(body, at: moment, for: account)
        return true
    }
}
