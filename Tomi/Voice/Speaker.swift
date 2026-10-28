/// Anything that can say a line aloud. Screens speak through this and never touch a speech engine,
/// so the engine can be replaced without changing a screen.
protocol Speaker {
    /// Says the line and returns when it has been spoken in full or was stopped.
    /// Throws when the engine cannot speak, and `CancellationError` when the calling task is cancelled.
    func speak(_ line: String) async throws

    /// Stops at once. Does nothing when nothing is being said.
    func stop()
}
