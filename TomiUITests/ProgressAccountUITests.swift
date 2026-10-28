import XCTest

/// A second cook who opens the app offline must not see the first cook's saved progress.
final class ProgressAccountUITests: XCTestCase {
    override func setUp() { continueAfterFailure = false }

    @MainActor func testOtherAccountOfflineLight() { checkOtherAccount("--appearance-light", name: "light") }
    @MainActor func testOtherAccountOfflineDark() { checkOtherAccount("--appearance-dark", name: "dark") }

    @MainActor private func checkOtherAccount(_ appearance: String, name: String) {
        seedFirstAccount()
        let args =
            XCUIApplication.returningCook + [
                "--store-ui-test-file", "--fake-other-account", "--fake-cook-entries-offline", appearance,
            ]
        let app = XCUIApplication.launched(args)
        assertNoPreviousProgress(app)
        attachScreenshot(of: app, named: "other-account-offline-\(name)")
    }

    @MainActor private func assertNoPreviousProgress(_ app: XCUIApplication) {
        let note = app.staticTexts["home-progress-note"]
        XCTAssertTrue(note.waitForExistence(timeout: 5))
        XCTAssertEqual(note.label, "Your progress will show when you're online.")
        XCTAssertFalse(app.otherElements["home-progress-strip"].exists)
    }

    @MainActor private func seedFirstAccount() {
        let args = XCUIApplication.returningCook + ["--store-ui-test-file", "--seed-known-state"]
        let app = XCUIApplication.launched(args)
        XCTAssertTrue(app.otherElements["home-progress-strip"].waitForExistence(timeout: 5))
        XCTAssertEqual(app.otherElements["home-progress-strip"].value as? String, "350 XP; 1 technique mastered")
        app.terminate()
    }
}
