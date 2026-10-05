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

    /// Changes the phone appearance with the welcome visible, checks the title is on screen and
    /// returns how bright the ground behind it is.
    @MainActor
    private func groundBrightnessOfWelcome(in appearance: XCUIDevice.Appearance) -> Double {
        prepareAppearance()
        let app = XCUIApplication()
        app.launchArguments = ["--store-in-memory"]
        app.launch()

        XCTAssertTrue(app.staticTexts["welcome-title"].waitForExistence(timeout: 5))
        XCUIDevice.shared.appearance = appearance
        waitForAppearance(appearance, in: app)
        return app.screenshot().groundBrightness
    }
    @MainActor private func prepareAppearance() {
        let original = XCUIDevice.shared.appearance
        XCUIDevice.shared.appearance = .light
        addTeardownBlock { @MainActor in XCUIDevice.shared.appearance = original }
    }

    /// Appearance updates arrive after the app is visible; wait for the rendered ground, not a delay.
    @MainActor private func waitForAppearance(_ appearance: XCUIDevice.Appearance, in app: XCUIApplication) {
        let expected = NSPredicate { _, _ in
            let brightness = app.screenshot().groundBrightness
            if appearance == .dark { return brightness < 0.25 }
            return brightness > 0.8
        }
        let settled = XCTNSPredicateExpectation(predicate: expected, object: app)
        wait(for: [settled], timeout: 5)
    }
}
