extension CookOutbox {
    /// When the outbox is sent again after this failure.
    public static func wait(after failure: OutboxFailure) -> OutboxWait {
        switch failure {
        case .notSignedIn: .untilSignIn
        case .requestUnreadable: .untilLaunch
        case .other: .withBackoff
        }
    }
}
