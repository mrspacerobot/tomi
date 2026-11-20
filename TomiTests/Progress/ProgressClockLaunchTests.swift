import Foundation
import Testing

@testable import Tomi

/// With the fake server, Home's progress reads the fake server's clock, so UI tests never depend on the date.
@MainActor
@Suite struct ProgressClockLaunchTests {
    @Test(arguments: FakeProgressFixture.allCases)
    func theFakeClockIsInTheWeekOfEveryFixture(_ fixture: FakeProgressFixture) throws {
        let snapshot = try fixture.snapshot()
        let now = ProgressClock.forLaunch(BackendLaunchOptions(arguments: ["--fake-backend"])).now()
        #expect(now >= snapshot.computedAt.date)
        #expect(now < snapshot.streak.weekEndsAt.date)
    }

    @Test func theFakeClockIsTheMomentTheChosenFixtureWasComputed() throws {
        let arguments = ["--fake-backend", "--fake-progress-returning"]
        let now = ProgressClock.forLaunch(BackendLaunchOptions(arguments: arguments)).now()
        #expect(now == (try FakeProgressFixture.returning.snapshot().computedAt.date))
    }

    /// The phone's clock runs on past the week the fake fixtures were computed in.
    @Test func theCooksOwnLaunchReadsThePhonesClock() throws {
        let fixtureWeekEnds = try FakeProgressFixture.returning.snapshot().streak.weekEndsAt.date
        let now = ProgressClock.forLaunch(BackendLaunchOptions(arguments: [])).now()
        #expect(now > fixtureWeekEnds)
    }
}
