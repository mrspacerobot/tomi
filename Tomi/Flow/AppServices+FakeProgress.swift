import Foundation
import TomiCore

extension AppServices {
    /// A cook who starts signed in has been here before: as the fake server holds the answers saved on the phone,
    /// it holds the progress the phone saved last, when that is one of its fixtures. So a relaunch shows the same
    /// progress after the server is asked again. A fixture named by launch argument wins.
    static func fakeServer(_ options: BackendLaunchOptions, store: any ProgressStore) -> FakeTomiAPIConfiguration {
        var configuration = options.fakeServer
        guard options.startsSignedIn, !configuration.progressServer.isFixtureNamed else {
            return configuration
        }
        if let saved = savedFixture(in: store) {
            configuration.progressServer.fixture = saved
        }
        return configuration
    }

    private static func savedFixture(in store: any ProgressStore) -> FakeProgressFixture? {
        guard let saved = try? store.progressSnapshot() else {
            return nil
        }
        return FakeProgressFixture.allCases.first { fixture in
            let snapshot = try? fixture.snapshot()
            return snapshot == saved
        }
    }
}
