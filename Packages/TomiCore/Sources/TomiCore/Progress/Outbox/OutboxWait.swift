/// What the outbox does after a failed try. Every cook stays in the outbox in each case; only when it is sent again
/// differs.
public enum OutboxWait: Hashable, Sendable {
    /// Until the next launch, which may be a newer app that can write the batch the server could not read.
    case untilLaunch
    /// Until the cook signs in again. Trying sooner would fail the same way.
    case untilSignIn
    /// Try again by itself after a wait that grows with every failure in a row (`CookOutbox.retryDelay`).
    case withBackoff
}
