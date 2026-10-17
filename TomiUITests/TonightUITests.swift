import XCTest

/// A returning cook against the fake server: no dish tonight, typing instead of a photo,
/// and taking an avoid item off the list, which needs the cook's yes.
final class TonightUITests: XCTestCase {
    override func setUp() {
        continueAfterFailure = false
    }

    @MainActor
    func testNoDishTonightIsAKindEmptyState() {
        let app = XCUIApplication.launched(XCUIApplication.returningCook + ["--store-in-memory", "--fake-no-specials"])
        XCTAssertTrue(app.buttons["home-scan"].waitForExistence(timeout: 5))
        app.buttons["home-scan"].tap()
        XCTAssertTrue(app.buttons["scan-type-instead"].waitForExistence(timeout: 5))
        app.buttons["scan-type-instead"].tap()
        XCTAssertTrue(app.buttons["confirm-find"].waitForExistence(timeout: 5))
        app.buttons["confirm-find"].tap()
        XCTAssertTrue(app.element("nothing-tonight-title").waitForExistence(timeout: 5))
        XCTAssertFalse(app.element("problem").exists)
    }

    @MainActor
    func testRemovingAnAvoidItemAsksTheCookFirst() {
        let app = XCUIApplication.launched(XCUIApplication.returningCook + ["--store-in-memory"])
        changeAvoidItem(app)
        changeAvoidItem(app)
        // The dialog's button is a button wrapped in a button with the same identifier, so take the first.
        let yes = app.buttons["confirm-removal-yes"].firstMatch
        XCTAssertTrue(yes.waitForExistence(timeout: 5))
        yes.tap()
        XCTAssertTrue(app.element("settings-question-avoid").waitForExistence(timeout: 5))
    }

    /// Opens the avoid question from settings, taps one item and saves.
    @MainActor private func changeAvoidItem(_ app: XCUIApplication) {
        if app.buttons["home-settings"].waitForExistence(timeout: 5) {
            app.buttons["home-settings"].tap()
        }
        XCTAssertTrue(app.element("settings-question-avoid").waitForExistence(timeout: 5))
        app.element("settings-question-avoid").tap()
        XCTAssertTrue(app.element("choice-fake-nuts").waitForExistence(timeout: 5))
        app.element("choice-fake-nuts").tap()
        app.buttons["settings-save"].tap()
    }
}
