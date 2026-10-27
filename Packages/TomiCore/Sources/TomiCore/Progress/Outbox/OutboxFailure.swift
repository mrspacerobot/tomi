/// Why a batch of cooks was not acknowledged, as far as the outbox rules need to tell failures apart.
/// The upload service puts what it saw into one of these, and `CookOutbox.wait(after:)` says what follows.
public enum OutboxFailure: Hashable, Sendable {
    /// Nobody is signed in, or the session could not be renewed.
    case notSignedIn
    /// The server answered that it could not read the batch (`422`). The same batch would fail the same way.
    case requestUnreadable
    /// The phone could not reach the server, or the server failed or answered with something unknown.
    case other
}
