import XCTest

/// Saved answers and progress are still there after the app was closed.
/// The tests keep their data in the UI tests' own store file or in memory, never in the cook's store.
final class SavedDataUITests: XCTestCase {
    override func setUp() {
        continueAfterFailure = false
    }

    /// The fake server is offline, so the seeded cooks stay unsent: online, the uploader would hand them to the
    /// server, and the progress worked out on the phone shows only unsent cooks until #163 shows the server's.
    @MainActor
    func testSeededProgressIsStillShownAfterARelaunch() {
        let seeded = launch(["--store-ui-test-file", "--seed-known-state", "--fake-cook-entries-offline"])
        assertKnownProgressIsShown(in: seeded)
        seeded.terminate()

        let relaunched = launch(["--store-ui-test-file", "--fake-cook-entries-offline"])
        assertKnownProgressIsShown(in: relaunched)
    }

    @MainActor
    func testAnEmptyStoreShowsNoProgress() {
        let app = launch(["--store-in-memory"])
        XCTAssertTrue(app.otherElements["home-progress-strip"].waitForExistence(timeout: 5))
        XCTAssertEqual(app.otherElements["home-progress-strip"].value as? String, "0 XP; 0 techniques mastered")
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
        XCTAssertFalse(app.staticTexts["home-title"].exists)
        XCTAssertFalse(app.otherElements["home-progress-strip"].exists)
    }

    /// The known cook state continues to show game progress and course menu after relaunch.
    @MainActor
    private func assertKnownProgressIsShown(in app: XCUIApplication) {
        XCTAssertTrue(app.otherElements["home-progress-strip"].waitForExistence(timeout: 5))
        XCTAssertEqual(app.otherElements["home-progress-strip"].value as? String, "360 XP; 4 techniques mastered")
        XCTAssertTrue(app.otherElements["home-menu"].exists)
    }

    @MainActor
    private func launch(_ arguments: [String]) -> XCUIApplication {
        XCUIApplication.launched(XCUIApplication.returningCook + arguments)
    }
}
