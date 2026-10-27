/// The server's answer to `POST /v1/cook-entries`: one result per entry, in the order they were sent,
/// and the progress snapshot after the batch.
public struct CookEntriesAnswer: Hashable, Decodable, Sendable {
    public let results: [CookEntryResult]
    /// Nil when the answer has no snapshot or one this app cannot read. Such a snapshot is never read as zero,
    /// and it never costs the results: they say which cooks the server has, so none is sent again for nothing.
    public let progress: ProgressSnapshot?

    enum CodingKeys: String, CodingKey {
        case results, progress
    }

    public init(results: [CookEntryResult], progress: ProgressSnapshot?) {
        self.results = results
        self.progress = progress
    }

    public init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        results = try values.decode([CookEntryResult].self, forKey: .results)
        progress = try? values.decodeIfPresent(ProgressSnapshot.self, forKey: .progress)
    }
}
