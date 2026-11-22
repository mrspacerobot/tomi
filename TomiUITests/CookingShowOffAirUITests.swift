import XCTest

final class CookingShowOffAirUITests: XCTestCase {
    override func setUp() { continueAfterFailure = false }

    @MainActor func testOffAirInMorningLighting() {
        visit(appearance: "light")
    }

    @MainActor func testOffAirInEveningLighting() {
        visit(appearance: "dark")
    }

    @MainActor private func visit(appearance: String) {
        let common = XCUIApplication.returningCook + ["--appearance-\(appearance)"]
        let offline = common + ["--store-ui-test-file", "--seed-known-state", "--fake-cook-entries-offline"]
        let app = XCUIApplication.launched(offline)
        XCTAssertTrue(app.element("off-air-badge").waitForExistence(timeout: 5))
        XCTAssertTrue(app.otherElements["home-progress-strip"].exists)
        capture("offline-\(appearance)", in: app)
        openUnreadableStore(common, appearance: appearance, in: app)
        openServerFailure(common, appearance: appearance, in: app)
    }

    @MainActor private func openUnreadableStore(_ common: [String], appearance: String, in app: XCUIApplication) {
        app.terminate()
        app.launchArguments = common + ["--store-unavailable"]
        app.launch()
        XCTAssertTrue(app.staticTexts["saved-data-unavailable-title"].waitForExistence(timeout: 5))
        XCTAssertFalse(app.otherElements["home-progress-strip"].exists)
        capture("lost-the-script-\(appearance)", in: app)
    }

    @MainActor private func openServerFailure(_ common: [String], appearance: String, in app: XCUIApplication) {
        app.terminate()
        app.launchArguments = common + ["--store-in-memory", "--fake-options-unavailable"]
        app.launch()
        XCTAssertTrue(app.buttons["load-failed-retry"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.element("off-air-stand-by").exists)
        capture("stand-by-\(appearance)", in: app)
        app.buttons["load-failed-retry"].tap()
        XCTAssertTrue(app.buttons["load-failed-retry"].waitForExistence(timeout: 5))
    }

    @MainActor private func capture(_ name: String, in app: XCUIApplication) {
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
