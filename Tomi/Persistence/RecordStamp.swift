import Foundation
import TomiCore

/// The id and the time of a stored record, so that TomiCore's one rule for "newest" also picks among records.
nonisolated struct RecordStamp: StampedRecord {
    let stableID: UUID?
    let updatedAt: Date?
}
