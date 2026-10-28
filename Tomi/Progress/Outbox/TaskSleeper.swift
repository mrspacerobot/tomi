/// Waits for real, for as long as asked, and stops early when its task is cancelled.
struct TaskSleeper: Sleeper {
    func sleep(for duration: Duration) async throws {
        try await Task.sleep(for: duration)
    }
}
