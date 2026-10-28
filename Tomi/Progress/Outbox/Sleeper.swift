/// Waits for a while, so the uploader's backoff never reads the clock itself and a test can decide when time
/// passes. `TaskSleeper` waits for real.
protocol Sleeper {
    /// Returns once the time has passed. Throws when the wait is cancelled, and the waiting work then stops.
    func sleep(for duration: Duration) async throws
}
