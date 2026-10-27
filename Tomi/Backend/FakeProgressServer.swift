import Foundation
import TomiCore

/// The fake server's progress routes. It answers every call with the chosen fixture snapshot, unchanged, and says
/// it has every cook it is sent. It counts nothing: the snapshot stays the fixture whatever is sent.
nonisolated struct FakeProgressServer: Equatable, Sendable {
    var fixture = FakeProgressFixture.newCook
    /// Both calls fail as if the phone could not reach the server, so the cooks stay in the outbox.
    var isOffline = false

    func progress() throws -> ProgressSnapshot {
        try checkOnline()
        return try fixture.snapshot()
    }

    func answer(_ request: CookEntriesRequest) throws -> CookEntriesAnswer {
        try checkOnline()
        let results = request.entries.map { CookEntryResult(id: $0.id, status: .accepted) }
        return CookEntriesAnswer(results: results, progress: try fixture.snapshot())
    }

    private func checkOnline() throws {
        if isOffline {
            throw BackendError.unreachable
        }
    }
}
