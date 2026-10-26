import XCTest

final class CookingStepsScrollUITests: XCTestCase {
    override func setUp() { continueAfterFailure = false }

    @MainActor func testChangingStepsShowsTheBeginningAtLargestTextSize() {
        let (app, _) = cookingIntroduction(extra: GalleryLayoutUITests.largestTextSize)
        app.buttons["cooking-start"].tap()
        app.buttons["cooking-steps-begin"].tap()
        app.buttons["cooking-step-next"].tap()
        assertProgressIsVisible(app, "Step 2 of 3")
        app.buttons["cooking-step-previous"].tap()
        assertProgressIsVisible(app, "Step 1 of 3")
    }

    @MainActor private func assertProgressIsVisible(_ app: XCUIApplication, _ words: String) {
        let progress = app.staticTexts.matching(NSPredicate(format: "label =[c] %@", words)).firstMatch
        XCTAssertTrue(progress.waitForExistence(timeout: 5))
        XCTAssertGreaterThanOrEqual(progress.frame.minY, app.navigationBars.firstMatch.frame.maxY)
    }
}
