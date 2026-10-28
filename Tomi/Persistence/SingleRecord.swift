import Foundation
import SwiftData

/// A kind of record the store should hold one of: the profile, the lesson in progress, the last progress snapshot.
/// Each carries a stable id and the moment it was last changed, so the newest can be told from a stale copy.
protocol SingleRecord: PersistentModel {
    var stableID: UUID? { get set }
    var updatedAt: Date? { get set }

    init()
}

extension ProfileRecord: SingleRecord {}

extension ActiveLessonRecord: SingleRecord {}

/// A snapshot is never changed, only replaced by the next one, so it was last changed when it was received.
extension ProgressSnapshotRecord: SingleRecord {
    var updatedAt: Date? {
        get { receivedAt }
        set { receivedAt = newValue }
    }
}
