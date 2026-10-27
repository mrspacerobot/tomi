import Foundation

/// The answer to `GET /v1/progress`: the snapshot read, and its JSON exactly as it arrived, for the store.
public struct ProgressResponse: Hashable, Sendable {
    public let snapshot: ProgressSnapshot
    public let body: Data

    public init(snapshot: ProgressSnapshot, body: Data) {
        self.snapshot = snapshot
        self.body = body
    }

    /// Throws when the snapshot cannot be read, so it is never kept or shown.
    public init(reading data: Data) throws {
        snapshot = try JSONDecoder().decode(ProgressSnapshot.self, from: data)
        body = data
    }
}
