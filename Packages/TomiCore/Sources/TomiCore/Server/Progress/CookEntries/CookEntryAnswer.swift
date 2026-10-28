/// The server's answer to `POST /v1/cook-entries`: the result for the entry that was sent, and the progress
/// snapshot after it.
public struct CookEntryAnswer: Hashable, Decodable, Sendable {
    public let result: CookEntryResult
    /// Nil when the answer has no snapshot or one this app cannot read. Such a snapshot is never read as zero,
    /// and it never costs the result: that says whether the server has the cook, so it is not sent again for nothing.
    public let progress: ProgressSnapshot?

    enum CodingKeys: String, CodingKey {
        case result, progress
    }

    public init(result: CookEntryResult, progress: ProgressSnapshot?) {
        self.result = result
        self.progress = progress
    }

    public init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        result = try values.decode(CookEntryResult.self, forKey: .result)
        progress = try? values.decodeIfPresent(ProgressSnapshot.self, forKey: .progress)
    }
}
