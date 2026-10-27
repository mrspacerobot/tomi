import Foundation
import TomiCore

/// The backoff: after a failed try, the uploader tries again by itself, each failure in a row waiting longer.
extension CookEntryUploader {
    /// Sets the timer for the next try, `CookOutbox.retryDelay` after this many failures in a row.
    func tryAgainLater() {
        failedTries += 1
        let delay = CookOutbox.retryDelay(afterFailedAttempts: failedTries)
        nextTryDelay = delay
        timer = Task { [weak self, sleeper = clock.sleeper] in
            if await Self.waitedOut(delay, with: sleeper) {
                self?.timerEnded()
            }
        }
    }

    /// False when the wait was cancelled: a trigger started the next try first, or the uploader is gone.
    private static func waitedOut(_ delay: Duration, with sleeper: any Sleeper) async -> Bool {
        do {
            try await sleeper.sleep(for: delay)
            return true
        } catch {
            return false
        }
    }

    func stopTimer() {
        timer?.cancel()
        timer = nil
        nextTryDelay = nil
    }

    /// The timer's own task is not cancelled here: it is the one starting this try.
    private func timerEnded() {
        timer = nil
        nextTryDelay = nil
        upload()
    }
}
