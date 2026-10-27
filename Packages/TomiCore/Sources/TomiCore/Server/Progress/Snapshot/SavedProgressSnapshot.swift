import Foundation

/// The last progress snapshot as it lies in the store: one value per stored field, under the stored field's name.
/// The body is the server's JSON exactly as it arrived, so the store holds no rule and reading it is done here.
/// Every field may be missing. Field names are permanent once released: add fields, never rename or remove one.
public struct SavedProgressSnapshot: StampedRecord, Hashable, Sendable {
    public var stableID: UUID?
    /// When the phone received the snapshot, by its own clock. The server's own time is in the body.
    public var receivedAt: Date?
    public var body: Data?

    public init() {}

    /// A snapshot is never changed, only replaced by the next one received, so it is stamped by its arrival.
    public var updatedAt: Date? {
        receivedAt
    }
}
