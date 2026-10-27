import Foundation
import OSLog
import Observation
import TomiCore

/// The cook's progress as Home shows it: the snapshot saved last at once, then the server's, with a kind note
/// when cooks wait to be sent. It shows only what the server sent and never adds a cook, XP or a rank of its own.
@Observable
final class ProgressModel {
    private static let logger = Logger(category: .progress)

    /// Nil when saved data cannot be read. Nothing may be shown then: the screen says saved data is unavailable.
    private(set) var shown: ShownProgress?
    /// The server could not be reached the last time it was asked.
    private var isOffline = false
    private let store: any ProgressStore
    private let server: ProgressServer
    private let clock: ProgressClock

    init(store: any ProgressStore, server: ProgressServer, clock: ProgressClock) {
        self.store = store
        self.server = server
        self.clock = clock
        reload()
    }

    /// Reads the snapshot saved last and the unsent cooks again, such as after the uploader kept an answer.
    func reload() {
        do {
            let situation = ProgressSituation(unsentCooks: try unsentCooks(), isOffline: isOffline)
            shown = ShownProgress(snapshot: try store.progressSnapshot(), situation: situation, now: clock.now())
        } catch {
            Self.logger.error("Saved data could not be read: \(String(describing: error), privacy: .public)")
            shown = nil
        }
    }

    /// The cooks of the signed-in account that wait to be sent. With nobody signed in there are none to speak of.
    private func unsentCooks() throws -> Int {
        guard let account = server.accountID else {
            return 0
        }
        return try store.pendingCookEntries(for: account).count
    }

    /// Asks the server, keeps its snapshot as it was sent, and shows it. When the server cannot be reached, the
    /// snapshot saved last stays, and the note says what will count once the cook is back online.
    func refresh() async {
        guard let api = server.api else {
            return
        }
        await ask(api)
        reload()
    }

    private func ask(_ api: any TomiAPI) async {
        do {
            let response = try await api.progress(CalendarContext(calendar: clock.calendar()))
            isOffline = false
            keep(response.body)
        } catch {
            Self.logger.notice("Progress was not read: \(String(describing: error), privacy: .public)")
            isOffline = true
        }
    }

    private func keep(_ body: Data) {
        do {
            try store.keepProgressSnapshot(body, at: clock.now())
        } catch {
            Self.logger.error("The snapshot could not be kept: \(String(describing: error), privacy: .public)")
        }
    }
}
