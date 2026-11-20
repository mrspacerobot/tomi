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

    @Test func theCooksOwnLaunchKeepsThePhonesClock() {
        let moment = Date(timeIntervalSinceReferenceDate: 800_000_000)
        let phone = ProgressClock(now: { moment }, calendar: { Calendar(identifier: .gregorian) })
        let clock = ProgressClock.forLaunch(BackendLaunchOptions(arguments: []), phone: phone)
        #expect(clock.now() == moment)
    }

    @Test func aFakeLaunchIgnoresThePhonesClock() throws {
        let moment = Date(timeIntervalSinceReferenceDate: 800_000_000)
        let phone = ProgressClock(now: { moment }, calendar: { Calendar(identifier: .gregorian) })
        let clock = ProgressClock.forLaunch(BackendLaunchOptions(arguments: ["--fake-backend"]), phone: phone)
        #expect(clock.now() == (try FakeProgressFixture.newCook.snapshot().computedAt.date))
    }
}
