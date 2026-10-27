import Testing

@testable import Tomi

/// UI tests choose the fake server's progress by launch argument.
@MainActor
@Suite struct FakeProgressLaunchTests {
    @Test func withoutAnArgumentTheFakeCookIsNew() {
        let options = BackendLaunchOptions(arguments: ["--fake-backend"])
        #expect(options.fakeServer.progressServer.fixture == .newCook)
        #expect(!options.fakeServer.progressServer.isOffline)
    }

    @Test func eachArgumentChoosesItsFixture() {
        #expect(
            BackendLaunchOptions(arguments: ["--fake-progress-new-cook"]).fakeServer.progressServer.fixture == .newCook
        )
        #expect(
            BackendLaunchOptions(arguments: ["--fake-progress-returning"]).fakeServer.progressServer.fixture
                == .returning
        )
    }

    @Test func theOfflineArgumentFailsTheProgressCalls() {
        #expect(BackendLaunchOptions(arguments: ["--fake-cook-entries-offline"]).fakeServer.progressServer.isOffline)
    }

    @Test func theLaunchedFakeAnswersWithTheChosenFixture() async throws {
        let options = BackendLaunchOptions(arguments: ["--fake-backend", "--fake-progress-returning"])
        let services = try #require(await AppServices.forLaunch(options, store: InMemoryProgressStore()))
        let snapshot = try await services.api.progress(.init(timeZone: "Europe/Amsterdam", firstWeekday: 2))
        #expect(snapshot.xp == 350)
    }
}
