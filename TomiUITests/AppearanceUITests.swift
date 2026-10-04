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

    /// Launches the app with the phone in the given appearance, checks the title is on screen and
    /// returns how bright the ground behind it is.
    @MainActor
    private func groundBrightnessOfWelcome(in appearance: XCUIDevice.Appearance) -> Double {
        XCUIDevice.shared.appearance = appearance
        addTeardownBlock { @MainActor in
            XCUIDevice.shared.appearance = .light
        }
        let app = XCUIApplication()
        app.launch()

        XCTAssertTrue(app.staticTexts["welcome-title"].waitForExistence(timeout: 5))
        return app.screenshot().groundBrightness
    }
}
