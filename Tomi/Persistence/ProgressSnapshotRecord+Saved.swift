import Foundation
import TomiCore

/// Copies the stored fields to and from the plain value TomiCore reads. No rule lives here.
extension ProgressSnapshotRecord {
    var saved: SavedProgressSnapshot {
        var saved = SavedProgressSnapshot()
        saved.stableID = stableID
        saved.receivedAt = receivedAt
        saved.body = body
        return saved
    }

    /// Takes the body. The id and the moment it was received belong to the store and are left as they are.
    func write(body: Data) {
        self.body = body
    }
}
