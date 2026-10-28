import XCTest

/// Finishing the steps of a recipe writes the cook to the phone, where it waits for the server: Home names it after
/// the app is opened again offline.
final class CookingRecordUITests: XCTestCase {
    private static let offline = ["--fake-cook-entries-offline"]

    override func setUp() { continueAfterFailure = false }

    @MainActor
    func testAFinishedCookWaitsOnThePhoneUntilTheServerCanCountIt() {
        finishACook()
        let home = XCUIApplication.launched(
            XCUIApplication.returningCook + ["--store-ui-test-file"] + Self.offline
        )
        let note = home.staticTexts["home-progress-note"]
        XCTAssertTrue(note.waitForExistence(timeout: 5))
        // The known state holds six unsent cooks and a snapshot; the cook just made is the seventh.
        XCTAssertTrue(note.label.hasPrefix("7 cooks"), note.label)
    }

    @MainActor private func finishACook() {
        let cooking = cookingIntroduction(store: "--store-ui-test-file", extra: Self.offline + ["--seed-known-state"])
            .0
        beginAndWalkAllSteps(cooking)
        cooking.buttons["cooking-steps-finish"].tap()
        XCTAssertTrue(cooking.element("suggestion-detail").waitForExistence(timeout: 5))
        cooking.terminate()
    }
}
