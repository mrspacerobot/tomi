import XCTest

/// Finishing the steps of a recipe writes the cook to the phone, where it waits for the server: Home names it after
/// the app is opened again offline.
final class CookingRecordUITests: XCTestCase {
    override func setUp() { continueAfterFailure = false }

    @MainActor
    func testAFinishedCookWaitsOnThePhoneUntilTheServerCanCountIt() {
        let offline = ["--store-start-empty", "--fake-cook-entries-offline"]
        let cooking = cookingIntroduction(store: "--store-ui-test-file", extra: offline).0
        beginAndWalkAllSteps(cooking)
        cooking.buttons["cooking-steps-finish"].tap()
        XCTAssertTrue(cooking.element("suggestion-detail").waitForExistence(timeout: 5))
        cooking.terminate()

        let home = XCUIApplication.launched(
            XCUIApplication.returningCook + ["--store-ui-test-file", "--fake-cook-entries-offline"]
        )
        let note = home.staticTexts["home-progress-note"]
        XCTAssertTrue(note.waitForExistence(timeout: 5))
        XCTAssertTrue(note.label.hasPrefix("1 cook"), note.label)
    }
}
