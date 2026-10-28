import Foundation
import SwiftData

/// The last progress snapshot the server sent, kept so progress can be shown without a connection.
/// `SavedProgressSnapshot` in TomiCore says what each field holds and how it is read. The body is the server's JSON
/// exactly as it arrived, so the record holds no rule. Saving a new snapshot replaces it.
///
/// The layout is kept safe for iCloud: every property is optional, nothing is unique, and it only ever grows.
/// The name of this type and of every property is permanent once released: never rename or remove one.
@Model
final class ProgressSnapshotRecord {
    var stableID: UUID?
    var receivedAt: Date?
    var body: Data?
    var account: String?

    init() {}
}
