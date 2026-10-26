import Foundation

/// The server's answer to one batch, read against the cooks that were sent in it.
/// The server answers each cook in the place it was sent, so a result is matched to the cook in its place,
/// and only when its id is that cook's or missing. An answer that does not line up changes nothing.
public struct OutboxReply: Sendable {
    public let sent: [CookEntryPayload]
    public let results: [CookEntryResult]

    public init(sent: [CookEntryPayload], results: [CookEntryResult]) {
        self.sent = sent
        self.results = results
    }

    /// What to do with each sent cook. A cook left out stays in the outbox as it is, to be sent again.
    public var changes: [UUID: OutboxChange] {
        guard sent.count == results.count else {
            return [:]
        }
        var changes: [UUID: OutboxChange] = [:]
        for (cook, result) in zip(sent, results) where result.answers(cook) {
            changes[cook.id] = result.status.outboxChange(problems: result.problems)
        }
        return changes
    }
}
