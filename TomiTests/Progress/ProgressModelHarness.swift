import Foundation
import TomiCore

@testable import Tomi

/// Builds a `ProgressModel` over a store and the fake server, on a fixed clock inside the example's week.
@MainActor
enum ProgressModelHarness {
    enum Server {
        case returning
        case offline
    }

    static func model(store: any ProgressStore, server: Server, now: Date = .october(27)) -> ProgressModel {
        ProgressModel(store: store, server: progressServer(server), clock: clock(at: now))
    }

    /// A store holding the backend's example snapshot, 360 XP, whose week ends on 1 November at 23:00 UTC.
    static func storeWithSnapshot() throws -> InMemoryProgressStore {
        let store = InMemoryProgressStore()
        try store.saveProgressSnapshot(ProgressSnapshotBody.example(), at: .october(26))
        return store
    }

    private static func progressServer(_ server: Server) -> ProgressServer {
        ProgressServer(api: api(server), auth: FakeAuthService(signedIn: true))
    }

    private static func api(_ server: Server) -> FakeTomiAPI {
        var progress = FakeProgressServer(fixture: .returning)
        progress.isOffline = server == .offline
        let configuration = FakeTomiAPIConfiguration(progressServer: progress)
        return FakeTomiAPI(library: BundledLessonLibrary(), configuration: configuration)
    }

    private static func clock(at now: Date) -> ProgressClock {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = .gmt
        return ProgressClock(now: { now }, calendar: { calendar })
    }
}
