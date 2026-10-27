import Foundation

/// The answer to `POST /v1/cook-entries` as it arrived: the results and the snapshot read, and the snapshot's own
/// JSON, which the phone keeps as the server sent it.
public struct CookEntriesResponse: Hashable, Sendable {
    static let snapshotKey = CookEntriesAnswer.CodingKeys.progress.stringValue

    public let answer: CookEntriesAnswer
    /// The snapshot object of the answer, every field kept, for `saveProgressSnapshot`. Nil when the answer has no
    /// snapshot this app can read, so such a snapshot never replaces the last one kept.
    public let snapshotBody: Data?

    public init(answer: CookEntriesAnswer, snapshotBody: Data?) {
        self.answer = answer
        self.snapshotBody = snapshotBody
    }

    /// Reads the answer's body. Throws when its results cannot be read.
    public init(reading data: Data) throws {
        let answer = try JSONDecoder().decode(CookEntriesAnswer.self, from: data)
        self.answer = answer
        if answer.progress == nil {
            snapshotBody = nil
        } else {
            snapshotBody = Self.snapshotObject(in: data)
        }
    }

    /// The snapshot object written out again on its own. Its fields and values are the server's; only the
    /// spacing and the order of the keys may differ from the bytes that arrived.
    private static func snapshotObject(in data: Data) -> Data? {
        guard let whole = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            return nil
        }
        guard let snapshot = whole[snapshotKey] else {
            return nil
        }
        return try? JSONSerialization.data(withJSONObject: snapshot, options: [.sortedKeys])
    }
}
