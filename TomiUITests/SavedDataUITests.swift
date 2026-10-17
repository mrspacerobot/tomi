import XCTest

/// Saved answers and progress are still there after the app was closed.
/// The tests keep their data in the UI tests' own store file or in memory, never in the cook's store.
final class SavedDataUITests: XCTestCase {
    override func setUp() {
        continueAfterFailure = false
    }

    @MainActor
    func testSeededProgressIsStillShownAfterARelaunch() {
        let seeded = launch(["--store-ui-test-file", "--seed-known-state"])
        assertKnownProgressIsShown(in: seeded)
        seeded.terminate()

        let relaunched = launch(["--store-ui-test-file"])
        assertKnownProgressIsShown(in: relaunched)
    }

    @MainActor
    func testAnEmptyStoreShowsNoProgress() {
        let app = launch(["--store-in-memory"])
        XCTAssertTrue(app.staticTexts["welcome-xp"].waitForExistence(timeout: 5))
        XCTAssertEqual(app.staticTexts["welcome-xp"].label, "0 XP")
        XCTAssertEqual(app.staticTexts["welcome-mastered"].label, "Techniques mastered: 0")
    }

    @MainActor
    func testSavedDataThatCannotBeOpenedShowsTheNoticeAndNothingElse() {
        let app = launch(["--store-unavailable"])
        assertSavedDataIsUnavailable(in: app)
    }

    @MainActor
    func testAnUnwritableStoreShowsTheNoticeInsteadOfAnEmptyProfile() {
        let app = launch(["--store-ui-test-unwritable-file"])
        assertSavedDataIsUnavailable(in: app)
    }

    @MainActor
    private func assertSavedDataIsUnavailable(in app: XCUIApplication) {
        XCTAssertTrue(app.staticTexts["saved-data-unavailable-title"].waitForExistence(timeout: 5))
        XCTAssertEqual(app.staticTexts["saved-data-unavailable-title"].label, "Tomi cannot read your saved answers")
        XCTAssertFalse(app.staticTexts["welcome-title"].exists)
        XCTAssertFalse(app.staticTexts["welcome-xp"].exists)
    }

    /// The known state of the shipped menu: the three techniques of the first course by the experience answer,
    /// and one technique of three levels cooked twice each with the quiz right, at 60 XP a cook.
    @MainActor
    private func assertKnownProgressIsShown(in app: XCUIApplication) {
        XCTAssertTrue(app.staticTexts["welcome-xp"].waitForExistence(timeout: 5))
        XCTAssertEqual(app.staticTexts["welcome-xp"].label, "360 XP")
        XCTAssertEqual(app.staticTexts["welcome-mastered"].label, "Techniques mastered: 4")
    }

    @MainActor
    private func launch(_ arguments: [String]) -> XCUIApplication {
        XCUIApplication.launched(XCUIApplication.returningCook + arguments)
    }
}
