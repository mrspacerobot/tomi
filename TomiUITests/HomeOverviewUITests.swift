import XCTest

/// The home overview is a readable menu, with supported actions and no invented dish.
final class HomeOverviewUITests: XCTestCase {
    override func setUp() {
        continueAfterFailure = false
    }

    @MainActor func testFirstEveningInLight() {
        captureHome(appearance: "light")
    }

    @MainActor func testFirstEveningInDark() {
        captureHome(appearance: "dark")
    }

    @MainActor func testReturningMenuInLight() {
        captureHome(appearance: "light", extra: ["--seed-known-state"])
    }

    @MainActor func testReturningMenuInDark() {
        captureHome(appearance: "dark", extra: ["--seed-known-state"])
    }

    @MainActor func testLargestTextKeepsTheMenuAndTypingReachable() {
        let app = launch(appearance: "dark", extra: GalleryLayoutUITests.largestTextSize)
        capture(app, name: "home-largest-top-dark")
        scrollTo(app.buttons["home-type"], in: app)
        capture(app, name: "home-largest-actions-dark")
        app.buttons["home-type"].tap()
        XCTAssertTrue(app.buttons["confirm-find"].waitForExistence(timeout: 5))
    }

    @MainActor private func captureHome(appearance: String, extra: [String] = []) {
        let app = launch(appearance: appearance, extra: extra)
        assertSettingsIsCompact(in: app)
        capture(app, name: "home-top-\(appearance)")
        app.swipeUp()
        capture(app, name: "home-menu-\(appearance)")
        XCTAssertTrue(app.otherElements["home-menu"].exists)
    }

    @MainActor private func launch(appearance: String, extra: [String]) -> XCUIApplication {
        let arguments = XCUIApplication.returningCook + ["--store-in-memory", "--appearance-\(appearance)"] + extra
        let app = XCUIApplication.launched(arguments)
        XCTAssertTrue(app.staticTexts["home-title"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.buttons["home-scan"].exists)
        XCTAssertFalse(
            app.buttons.matching(NSPredicate(format: "identifier BEGINSWITH 'suggestion-open-'")).firstMatch.exists
        )
        return app
    }

    @MainActor private func assertSettingsIsCompact(in app: XCUIApplication) {
        let settings = app.buttons["home-settings"]
        XCTAssertGreaterThanOrEqual(settings.frame.width, 44)
        XCTAssertGreaterThanOrEqual(settings.frame.height, 44)
        XCTAssertLessThan(settings.frame.width, app.frame.width / 3)
    }

    @MainActor private func scrollTo(_ element: XCUIElement, in app: XCUIApplication) {
        for _ in 0..<8 {
            if element.isHittable { return }
            app.swipeUp()
        }
        XCTAssertTrue(element.isHittable)
    }

    @MainActor private func capture(_ app: XCUIApplication, name: String) {
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
