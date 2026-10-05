import XCTest

/// Tomi follows the phone's appearance: paper in light, night ink in dark, and the welcome title in both.
final class AppearanceUITests: XCTestCase {
    override func setUp() {
        continueAfterFailure = false
    }

    @MainActor
    func testWelcomeShowsItsTitleOnPaperInLight() {
        let ground = groundBrightnessOfWelcome(in: .light)

        XCTAssertGreaterThan(ground, 0.8)
    }

    @MainActor
    func testWelcomeShowsItsTitleOnNightInkInDark() {
        let ground = groundBrightnessOfWelcome(in: .dark)

        XCTAssertLessThan(ground, 0.25)
    }

    /// Launches the app in the given appearance and returns how bright the ground behind the title is.
    /// The app is told the appearance by a launch argument, because `XCUIDevice.appearance` has no effect
    /// on this simulator and the test would then see whatever the phone happens to be set to.
    @MainActor
    private func groundBrightnessOfWelcome(in appearance: XCUIDevice.Appearance) -> Double {
        let app = XCUIApplication()
        app.launchArguments = ["--store-in-memory", "--seed-known-state", argument(for: appearance)]
        app.launch()

        XCTAssertTrue(app.staticTexts["welcome-title"].waitForExistence(timeout: 5))
        return app.screenshot().groundBrightness
    }

    private func argument(for appearance: XCUIDevice.Appearance) -> String {
        if appearance == .dark {
            return "--appearance-dark"
        }
        return "--appearance-light"
    }
}
