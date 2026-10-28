import Foundation
import OSLog
import TomiCore

/// What the server's answer to one cook does on the phone.
extension CookEntryUploader {
    /// Sends one cook and keeps what the answer says. True when the outbox changed, so the next cook can go.
    func send(_ request: CookEntryRequest, for account: String) async -> Bool {
        guard auth.accountID() == account else { return false }
        do {
            let response = try await api.sendCookEntry(request, for: account)
            guard auth.accountID() == account else { return false }
            return keep(response, for: request, account: account)
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
        Self.logger.error("The server could not read a request. The cooks wait for the next launch.")
        isHeldUntilLaunch = true
    }

    private func retryWithBackoff(after error: any Error) {
        Self.logger.notice("A cook was not sent: \(String(describing: error), privacy: .public)")
        tryAgainLater()
    }

    /// Keeps the snapshot, then forgets or refuses the cook the server answered for. An answer that changed nothing,
    /// such as one with a status this app does not know, counts as a failed try, so it is never resent in a tight
    /// loop.
    private func keep(_ response: CookEntryResponse, for request: CookEntryRequest, account: String) -> Bool {
        keepSnapshot(response.snapshotBody, for: account)
        logConflict(in: response.answer.result)
        let reply = OutboxReply(sent: request.entry, result: response.answer.result)
        guard let change = reply.change, apply(change, to: request.entry.id) else {
            tryAgainLater()
            return false
        }
        failedTries = 0
        return true
    }

    /// A refused cook stays on the phone with the server's code and is never sent again. Only the code is logged.
    private func apply(_ change: OutboxChange, to id: UUID) -> Bool {
        if case .refuse(let code) = change {
            Self.logger.notice("The server refused a cook: \(code.rawValue, privacy: .public)")
        }
        do {
            try store.apply(change, to: id)
            return true
        } catch {
            Self.logger.error("An answer could not be kept: \(String(describing: error), privacy: .public)")
            return false
        }
    }

    private func keepSnapshot(_ body: Data?, for account: String) {
        guard let body else {
            return
        }
        do {
            try store.keepProgressSnapshot(body, at: clock.now(), for: account)
        } catch {
            Self.logger.error("The snapshot could not be kept: \(String(describing: error), privacy: .public)")
        }
    }

    /// The server kept an earlier copy of this cook with a different body. Only the id and the status are logged.
    private func logConflict(in result: CookEntryResult) {
        guard result.status == .conflict, let id = result.id else {
            return
        }
        Self.logger.notice("Conflict: the server keeps its earlier copy of \(id.uuidString, privacy: .public)")
    }
}
