import Foundation
import OSLog
import TomiCore

/// What the server's answer to one batch does on the phone.
extension CookEntryUploader {
    /// Sends one batch and keeps what the answer says. True when the outbox changed, so the next batch can go.
    func send(_ batch: CookEntriesRequest) async -> Bool {
        do {
            let response = try await api.sendCookEntries(batch)
            return keep(response, for: batch)
        } catch {
            react(to: error)
            return false
        }
    }

    /// Every cook stays in the outbox after a failure. `CookOutbox.wait(after:)` says when it is sent again.
    private func react(to error: any Error) {
        let failure = (error as? BackendError)?.outboxFailure ?? .other
        switch CookOutbox.wait(after: failure) {
        case .untilLaunch: holdUntilLaunch()
        case .untilSignIn: Self.logger.notice("Nobody is signed in. The cooks wait for the next sign-in.")
        case .withBackoff: retryWithBackoff(after: error)
        }
    }

    private func holdUntilLaunch() {
        Self.logger.error("The server could not read a batch. The cooks wait for the next launch.")
        isHeldUntilLaunch = true
    }

    private func retryWithBackoff(after error: any Error) {
        Self.logger.notice("A batch was not sent: \(String(describing: error), privacy: .public)")
        tryAgainLater()
    }

    /// Keeps the snapshot, then forgets or refuses each cook the server answered for. An answer that changed no
    /// cook, such as one with a status this app does not know, counts as a failed try, so it is never resent in a
    /// tight loop.
    private func keep(_ response: CookEntriesResponse, for batch: CookEntriesRequest) -> Bool {
        keepSnapshot(response.snapshotBody)
        let changes = OutboxReply(sent: batch.entries, results: response.answer.results).changes
        logConflicts(in: response.answer.results)
        guard !changes.isEmpty, apply(changes) else {
            tryAgainLater()
            return false
        }
        failedTries = 0
        return true
    }

    private func apply(_ changes: [UUID: OutboxChange]) -> Bool {
        do {
            try store.forgetCookEntries(ids: forgotten(in: changes))
            try refuse(in: changes)
            return true
        } catch {
            Self.logger.error("An answer could not be kept: \(String(describing: error), privacy: .public)")
            return false
        }
    }

    private func forgotten(in changes: [UUID: OutboxChange]) -> Set<UUID> {
        var ids: Set<UUID> = []
        for (id, change) in changes where change == .forget {
            ids.insert(id)
        }
        return ids
    }

    /// A refused cook stays on the phone with the server's code and is never sent again. Only the code is logged.
    private func refuse(in changes: [UUID: OutboxChange]) throws {
        for case (let id, .refuse(let code)) in changes {
            Self.logger.notice("The server refused a cook: \(code.rawValue, privacy: .public)")
            try store.markCookEntryRefused(id: id, code: code)
        }
    }

    private func keepSnapshot(_ body: Data?) {
        guard let body else {
            return
        }
        do {
            try store.keepProgressSnapshot(body, at: clock.now())
        } catch {
            Self.logger.error("The snapshot could not be kept: \(String(describing: error), privacy: .public)")
        }
    }

    /// The server kept an earlier copy of these cooks with a different body. Only the id and the status are logged.
    private func logConflicts(in results: [CookEntryResult]) {
        for result in results where result.status == .conflict {
            if let id = result.id {
                Self.logger.notice("Conflict: the server keeps its earlier copy of \(id.uuidString, privacy: .public)")
            }
        }
    }
}
