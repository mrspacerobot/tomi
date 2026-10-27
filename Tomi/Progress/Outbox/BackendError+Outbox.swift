import TomiCore

extension BackendError {
    /// The kind of failure the outbox rules tell apart. Which one it is decides nothing here: `CookOutbox` does.
    var outboxFailure: OutboxFailure {
        switch self {
        case .notSignedIn: .notSignedIn
        case .server(status: 422, _): .batchUnreadable
        default: .other
        }
    }
}
