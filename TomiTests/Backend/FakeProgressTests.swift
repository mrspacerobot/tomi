import Foundation
import Testing
import TomiCore

@testable import Tomi

/// The fake server answers progress from fixture snapshots, unchanged. It computes nothing, so no game rule can
/// come back into the app through it.
@Suite struct FakeProgressTests {
    let amsterdam = CalendarContext(timeZone: "Europe/Amsterdam", firstWeekday: 2)

    func fake(_ fixture: FakeProgressFixture, offline: Bool = false) -> FakeTomiAPI {
        let server = FakeProgressServer(fixture: fixture, isOffline: offline)
        let configuration = FakeTomiAPIConfiguration(progressServer: server)
        return FakeTomiAPI(library: BundledLessonLibrary(), configuration: configuration)
    }

    func decoded(_ text: String) throws -> ProgressSnapshot {
        try JSONDecoder().decode(ProgressSnapshot.self, from: Data(text.utf8))
    }

    @Test func aNewCookGetsTheNewCookFixtureUnchanged() async throws {
        let snapshot = try await fake(.newCook).progress(amsterdam).snapshot
        #expect(snapshot == (try decoded(ProgressFixtureText.newCook)))
        #expect(snapshot.xp == 0)
    }

    @Test func theSnapshotComesWithTheFixturesBytes() async throws {
        let response = try await fake(.returning).progress(amsterdam)
        #expect(response.body == (try FakeProgressFixture.returning.body()))
    }

    @Test func aReturningCookGetsTheReturningFixtureUnchanged() async throws {
        let snapshot = try await fake(.returning).progress(amsterdam).snapshot
        #expect(snapshot == (try decoded(ProgressFixtureText.returning)))
        #expect(snapshot.xp == 350)
    }

    @Test func theFakeStartsAsANewCook() async throws {
        let snapshot = try await FakeTomiAPI(library: BundledLessonLibrary()).progress(amsterdam).snapshot
        #expect(snapshot == (try decoded(ProgressFixtureText.newCook)))
    }

    /// The real server would count the cook; the fake only says it has it, and its snapshot stays as it was.
    @Test func aSentCookIsAcceptedAndTheSnapshotStaysTheFixture() async throws {
        let request = CookEntryFixture.request()
        let response = try await fake(.returning).sendCookEntry(request)
        let answer = response.answer
        #expect(response.snapshotBody == (try FakeProgressFixture.returning.body()))
        #expect(answer.result.id == request.entry.id)
        #expect(answer.result.status == .accepted)
        #expect(answer.progress == (try decoded(ProgressFixtureText.returning)))
    }

    @Test func theCalendarAskedForChangesNothing() async throws {
        let api = fake(.returning)
        let amsterdamSnapshot = try await api.progress(amsterdam).snapshot
        let tokyo = try await api.progress(CalendarContext(timeZone: "Asia/Tokyo", firstWeekday: 1)).snapshot
        #expect(amsterdamSnapshot == tokyo)
    }

    @Test func offlineBothCallsFailAsTheNetworkWould() async {
        let api = fake(.returning, offline: true)
        await #expect(throws: BackendError.unreachable) { try await api.progress(amsterdam) }
        await #expect(throws: BackendError.unreachable) {
            try await api.sendCookEntry(CookEntryFixture.request())
        }
    }
}
