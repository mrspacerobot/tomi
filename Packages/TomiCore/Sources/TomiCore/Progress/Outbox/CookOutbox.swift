/// The rules of the outbox: the cook log on the phone, holding each cook until the server has acknowledged it.
/// The upload service asks these rules what to send, what each answer changes and how long to wait.
public enum CookOutbox {
    /// Kept as the code of a cook the server rejected without naming a problem, so it is still never resent.
    public static let unstatedProblem: CookEntryProblem = "unstated"
    /// The wait after the first failed try. Each further failure doubles it.
    public static let firstRetryDelay = Duration.seconds(2)
    /// The wait never grows past this, so a cook back online is counted within a quarter of an hour.
    public static let longestRetryDelay = Duration.seconds(15 * 60)

    /// How long to wait before the next try, from the failed tries in a row so far. No clock is read.
    public static func retryDelay(afterFailedAttempts failures: Int) -> Duration {
        guard failures > 0 else {
            return .zero
        }
        var delay = firstRetryDelay
        var doublingsLeft = failures - 1
        while doublingsLeft > 0 && delay < longestRetryDelay {
            delay *= 2
            doublingsLeft -= 1
        }
        return min(delay, longestRetryDelay)
    }
}
