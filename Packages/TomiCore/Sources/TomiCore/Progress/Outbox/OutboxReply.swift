/// The server's answer to one cook, read against the cook that was sent.
/// The result counts for that cook only when its id is the cook's or missing. An answer that does not line up
/// changes nothing.
public struct OutboxReply: Sendable {
    public let sent: CookEntryPayload
    public let result: CookEntryResult

    public init(sent: CookEntryPayload, result: CookEntryResult) {
        self.sent = sent
        self.result = result
    }

    /// What to do with the sent cook. Nil leaves it in the outbox as it is, to be sent again.
    public var change: OutboxChange? {
        guard result.answers(sent) else {
            return nil
        }
        return result.status.outboxChange(problems: result.problems)
    }
}
