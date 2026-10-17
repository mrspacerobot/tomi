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
        let app = XCUIApplication.launched(XCUIApplication.returningCook + ["--store-in-memory"])

        XCTAssertTrue(app.staticTexts["welcome-title"].waitForExistence(timeout: 5))
        showAppearance(appearance, in: app)
        return app.screenshot().groundBrightness
    }
    @MainActor private func prepareAppearance() {
        let original = XCUIDevice.shared.appearance
        XCUIDevice.shared.appearance = .light
        addTeardownBlock { @MainActor in XCUIDevice.shared.appearance = original }
    }

    /// Starting from light, establish a rendered dark screen before asking for either final appearance.
    @MainActor private func showAppearance(_ appearance: XCUIDevice.Appearance, in app: XCUIApplication) {
        XCUIDevice.shared.appearance = .dark
        waitForAppearance(.dark, in: app)
        if appearance == .light {
            XCUIDevice.shared.appearance = .light
            waitForAppearance(.light, in: app)
        }
    }

}
