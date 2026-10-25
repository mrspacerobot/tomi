import XCTest

/// The question about what the cook never eats, opened from settings against the fake server: two groups,
/// every regulated allergen selectable, and a saved item the app cannot name that asks before it goes.
final class AvoidQuestionUITests: XCTestCase {
    override func setUp() {
        continueAfterFailure = false
    }

    @MainActor
    func testTheItemsAreShownInTheirTwoGroups() {
        let app = openAvoidQuestion(extra: [])
        XCTAssertTrue(app.element(labelled: "Common allergens").exists)
        XCTAssertTrue(app.element(labelled: "Other things you skip").exists)
        XCTAssertTrue(app.element("choice-fake-nuts").exists)
        XCTAssertLessThan(app.element("choice-fake-celery").frame.minY, app.element("choice-fake-pork").frame.minY)
        XCTAssertTrue(app.element("avoid-none").exists)
    }

    @MainActor
    func testARegulatedAllergenCanBeTickedAndSaved() {
        let app = openAvoidQuestion(extra: [])
        app.element("choice-fake-celery").tap()
        app.buttons["settings-save"].tap()
        XCTAssertTrue(app.element("settings-question-avoid").waitForExistence(timeout: 5))
        app.element("settings-question-avoid").tap()
        XCTAssertTrue(app.element("choice-fake-celery").isSelected)
    }

    @MainActor
    func testASavedItemTheAppCannotNameIsTickedAndAsksBeforeItGoes() {
        let app = openAvoidQuestion(extra: ["--fake-unlisted-avoid"])
        let row = app.element("choice-fake-from-a-newer-server")
        XCTAssertTrue(row.exists)
        XCTAssertTrue(row.isSelected)
        XCTAssertTrue(app.staticTexts["Saved earlier, I cannot name it"].exists)
        row.tap()
        app.buttons["settings-save"].tap()
        confirmTheRemoval(app)
        XCTAssertTrue(app.element("settings-question-avoid").waitForExistence(timeout: 5))
    }

    @MainActor private func confirmTheRemoval(_ app: XCUIApplication) {
        // The dialog's button is a button wrapped in a button with the same identifier, so take the first.
        let yes = app.buttons["confirm-removal-yes"].firstMatch
        XCTAssertTrue(yes.waitForExistence(timeout: 5))
        yes.tap()
    }

    @MainActor private func openAvoidQuestion(extra: [String]) -> XCUIApplication {
        let app = XCUIApplication.launched(XCUIApplication.returningCook + ["--store-in-memory"] + extra)
        XCTAssertTrue(app.buttons["home-settings"].waitForExistence(timeout: 5))
        app.buttons["home-settings"].tap()
        XCTAssertTrue(app.element("settings-question-avoid").waitForExistence(timeout: 5))
        app.element("settings-question-avoid").tap()
        XCTAssertTrue(app.element("choice-fake-nuts").waitForExistence(timeout: 5))
        return app
    }
}
