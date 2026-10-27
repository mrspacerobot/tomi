import Foundation
import TomiCore

/// The fake server's progress routes. It answers every call with the chosen fixture snapshot, unchanged, and says
/// it has every cook it is sent. It counts nothing: the snapshot stays the fixture whatever is sent.
nonisolated struct FakeProgressServer: Equatable, Sendable {
    var fixture = FakeProgressFixture.newCook
    /// Both calls fail as if the phone could not reach the server, so the cooks stay in the outbox.
    var isOffline = false
    /// A launch argument chose the fixture, so nothing saved on the phone changes it.
    var isFixtureNamed = false

    func progress() throws -> ProgressResponse {
        try checkOnline()
        return ProgressResponse(snapshot: try fixture.snapshot(), body: try fixture.body())
    }

    func answer(_ request: CookEntriesRequest) throws -> CookEntriesResponse {
        try checkOnline()
        let results = request.entries.map { CookEntryResult(id: $0.id, status: .accepted) }
        let answer = CookEntriesAnswer(results: results, progress: try fixture.snapshot())
        return CookEntriesResponse(answer: answer, snapshotBody: try fixture.body())
    }

    private func checkOnline() throws {
        if isOffline {
            throw BackendError.unreachable
        }
    }
}
