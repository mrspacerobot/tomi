import Foundation
import OSLog
import Observation
import TomiCore

/// Sends the outbox of unsent cooks to Tomi's server by itself: on launch, when the app becomes active, right after a
/// cook is saved, and when its backoff timer ends. One upload runs at a time, a batch after another until the outbox
/// is empty. Every cook keeps its id across every try, and the server is idempotent on it, so trying again is safe.
/// The uploader works nothing out: what each answer does to a cook and how long to wait are the outbox rules
/// (`CookOutbox`, `OutboxReply`), and the snapshot is kept as the server sent it.
@Observable
final class CookEntryUploader {
    static let logger = Logger(category: .progress)

    let api: any TomiAPI
    let store: any ProgressStore
    let clock: UploaderClock
    /// The upload running now. A trigger while it runs starts nothing.
    private var running: Task<Void, Never>?
    /// The wait before the next try, while one is set (`CookEntryUploader+Timer`).
    var timer: Task<Void, Never>?
    /// How long the timer that is set waits. Nil when none is set.
    var nextTryDelay: Duration?
    /// Tries that failed in a row, which set the next wait. A batch the server answers resets it.
    var failedTries = 0
    /// The server could not read a batch (`422`). The same batch would fail the same way, so every cook waits for
    /// the next launch, which may be a newer app.
    var isHeldUntilLaunch = false
    /// Batches tried since launch. It changes after every try, so Home reads the snapshot and the outbox again.
    private(set) var finishedTries = 0

    init(api: any TomiAPI, store: any ProgressStore, clock: UploaderClock) {
        self.api = api
        self.store = store
        self.clock = clock
    }

    /// Starts an upload, unless one runs already or the outbox waits for the next launch. A timer that was set
    /// is stopped: this try is the next one.
    func upload() {
        guard running == nil, !isHeldUntilLaunch else {
            return
        }
        stopTimer()
        running = Task {
            await sendEveryBatch()
            running = nil
        }
    }

    /// Returns once the upload running now, if any, has ended.
    func waitUntilIdle() async {
        if let running {
            await running.value
        }
    }

    private func sendEveryBatch() async {
        while let batch = nextBatch() {
            let outboxChanged = await send(batch)
            finishedTries += 1
            guard outboxChanged else {
                return
            }
        }
    }

    /// The oldest pending cooks, or nil when there are none or saved data cannot be read. Then nothing is sent:
    /// without the store, no answer could be kept.
    private func nextBatch() -> CookEntriesRequest? {
        do {
            let pending = try store.pendingCookEntries()
            guard !pending.isEmpty else {
                return nil
            }
            return pending.outboxBatch(calendar: clock.calendar())
        } catch {
            Self.logger.error("The outbox could not be read: \(String(describing: error), privacy: .public)")
            return nil
        }
    }
}
