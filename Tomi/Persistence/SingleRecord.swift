import Foundation
import SwiftData

/// A kind of record the store should hold one of: the profile, the lesson in progress.
/// Each carries a stable id and the moment it was last changed, so the newest can be told from a stale copy.
protocol SingleRecord: PersistentModel {
    var stableID: UUID? { get set }
    var updatedAt: Date? { get set }

    init()
}

extension ProfileRecord: SingleRecord {}

extension ActiveLessonRecord: SingleRecord {}
