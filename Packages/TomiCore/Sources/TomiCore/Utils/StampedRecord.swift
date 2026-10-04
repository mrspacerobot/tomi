import Foundation

/// A saved record with a stable id and the moment it was last changed.
/// Saved data has no unique constraints, so two devices can each save one and iCloud keeps both.
/// Reading then picks the newest by a rule that never depends on the order the records arrive in.
public protocol StampedRecord: Equatable {
    var stableID: UUID? { get }
    var updatedAt: Date? { get }
}

extension StampedRecord {
    /// Whether this record was changed later than the other. A record without a time is the oldest,
    /// and two records changed at the same moment are ordered by their ids.
    public func isNewer(than other: some StampedRecord) -> Bool {
        if changedAt != other.changedAt {
            return changedAt > other.changedAt
        }
        return idText > other.idText
    }

    fileprivate func hasSameStamp(as other: Self) -> Bool {
        changedAt == other.changedAt && idText == other.idText
    }

    private var changedAt: Date {
        guard let updatedAt else {
            return .distantPast
        }
        return updatedAt
    }

    private var idText: String {
        guard let stableID else {
            return ""
        }
        return stableID.uuidString
    }
}

extension Sequence where Element: StampedRecord {
    /// The record changed last. Nil when there is none or conflicting copies share its stamp.
    public var newest: Element? {
        guard let candidate = self.max(by: { older, newer in newer.isNewer(than: older) }) else {
            return nil
        }
        let hasConflict = contains { $0.hasSameStamp(as: candidate) && $0 != candidate }
        guard !hasConflict else {
            return nil
        }
        return candidate
    }
}
