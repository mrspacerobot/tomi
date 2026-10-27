import XCTest

/// Pictures of the cooking steps from the running app, for the pull request: each screen of the walk in light and
/// dark, and at the largest text size.
final class CookingStepsCaptureUITests: XCTestCase {
    override func setUp() { continueAfterFailure = false }

    @MainActor
    func testTheWalkInLightAppearance() {
        captureTheWalk(in: "light", extra: [])
    }

    @MainActor
    func testTheWalkInDarkAppearance() {
        captureTheWalk(in: "dark", extra: ["--appearance-dark"])
    }

    @MainActor
    func testTheStepsAtLargestTextInDarkAppearance() {
        let arguments = GalleryLayoutUITests.largestTextSize + ["--appearance-dark"]
        let (app, _) = cookingIntroduction(extra: arguments)
        showFirstStep(app, appearance: "largest-dark")
        showMiddleStep(app)
        attachScreenshot(of: app, named: "steps-middle-largest-dark")
        app.swipeUp()
        app.swipeUp()
        XCTAssertTrue(app.buttons["cooking-step-next"].isHittable)
        attachScreenshot(of: app, named: "steps-controls-largest-dark")
    }

    @MainActor private func captureTheWalk(in appearance: String, extra: [String]) {
        let (app, _) = cookingIntroduction(extra: extra)
        showFirstStep(app, appearance: appearance)
        showMiddleStep(app)
        attachScreenshot(of: app, named: "steps-middle-" + appearance)
        app.buttons["cooking-step-next"].tap()
        XCTAssertTrue(app.buttons["cooking-steps-finish"].waitForExistence(timeout: 5))
        attachScreenshot(of: app, named: "steps-last-" + appearance)
    }

    @MainActor private func showFirstStep(_ app: XCUIApplication, appearance: String) {
        app.buttons["cooking-start"].tap()
        XCTAssertTrue(app.buttons["cooking-steps-begin"].waitForExistence(timeout: 5))
        attachScreenshot(of: app, named: "preparation-begin-" + appearance)
        app.swipeUp()
        app.swipeUp()
        attachScreenshot(of: app, named: "preparation-footer-" + appearance)
        app.buttons["cooking-steps-begin"].tap()
        XCTAssertTrue(app.buttons["cooking-step-next"].waitForExistence(timeout: 5))
        attachScreenshot(of: app, named: "steps-first-" + appearance)
    }

    /// Moves to the second step and waits until it has been laid out, so the picture is of the settled screen.
    @MainActor private func showMiddleStep(_ app: XCUIApplication) {
        app.buttons["cooking-step-next"].tap()
        let time = app.staticTexts.matching(NSPredicate(format: "label CONTAINS 'min'")).firstMatch
        XCTAssertTrue(time.waitForExistence(timeout: 5))
        XCTAssertTrue(app.buttons["cooking-step-previous"].waitForExistence(timeout: 5))
        Thread.sleep(forTimeInterval: 1)
    }
}
