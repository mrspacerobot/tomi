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
        let response = try await services.api.progress(.init(timeZone: "Europe/Amsterdam", firstWeekday: 2))
        #expect(response.snapshot.xp == 350)
    }

    /// As it holds the answers saved on the phone, the fake server of a signed-in cook holds the progress the
    /// phone saved last, so a relaunch shows the same progress after the server is asked again.
    @Test func aSignedInFakeServesTheFixtureThePhoneSavedLast() async throws {
        let store = InMemoryProgressStore()
        try store.saveProgressSnapshot(try FakeProgressFixture.returning.body(), at: .october(26))
        let options = BackendLaunchOptions(arguments: ["--fake-backend", "--fake-signed-in"])
        let services = try #require(await AppServices.forLaunch(options, store: store))
        let response = try await services.api.progress(.init(timeZone: "Europe/Amsterdam", firstWeekday: 2))
        #expect(response.snapshot.xp == 350)
    }

    @Test func aFixtureNamedByArgumentWinsOverTheSavedOne() async throws {
        let store = InMemoryProgressStore()
        try store.saveProgressSnapshot(try FakeProgressFixture.returning.body(), at: .october(26))
        let arguments = ["--fake-backend", "--fake-signed-in", "--fake-progress-new-cook"]
        let services = try #require(
            await AppServices.forLaunch(BackendLaunchOptions(arguments: arguments), store: store)
        )
        let response = try await services.api.progress(.init(timeZone: "Europe/Amsterdam", firstWeekday: 2))
        #expect(response.snapshot.xp == 0)
    }
}
