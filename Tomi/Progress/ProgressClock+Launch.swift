import Foundation

/// Which clock a launch gives Home's progress.
extension ProgressClock {
    /// With the fake server, the moment its progress fixture was computed, so the fixture's week is always the week
    /// in progress and UI tests never depend on the date. The phone's own clock otherwise.
    static func forLaunch(_ options: BackendLaunchOptions) -> ProgressClock {
        guard options.usesFake, let moment = fakeServerMoment(options.fakeServer.progressServer.fixture) else {
            return .phone
        }
        return ProgressClock(now: { moment }, calendar: { Calendar.current })
    }

    /// Nil when the fixture cannot be read. Home then has no snapshot to compare with the clock at all.
    private static func fakeServerMoment(_ fixture: FakeProgressFixture) -> Date? {
        do {
            return try fixture.snapshot().computedAt.date
        } catch {
            return nil
        }
    }
}
