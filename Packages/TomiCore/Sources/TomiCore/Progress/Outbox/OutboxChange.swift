/// What the server's answer does to one cook in the outbox. A cook with no change stays as it is.
public enum OutboxChange: Hashable, Sendable {
    /// The server holds a copy that counts. The cook leaves the outbox.
    case forget
    /// The server rejected the cook for good. It stays on the phone, marked with the code, and is never resent.
    case refuse(code: CookEntryProblem)
}
