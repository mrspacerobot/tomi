import XCTest

/// Pictures of the quiz from the running app, for the pull request: a question, a wrong pick, a right pick with
/// the server's explanation, and offline, in light and dark and at the largest text size.
final class CookingQuizCaptureUITests: XCTestCase {
    override func setUp() { continueAfterFailure = false }

    @MainActor
    func testTheQuizInLightAppearance() {
        captureTheQuiz(in: "light", extra: [])
    }

    @MainActor
    func testTheQuizInDarkAppearance() {
        captureTheQuiz(in: "dark", extra: ["--appearance-dark"])
    }

    @MainActor
    func testTheQuizAtLargestTextInDarkAppearance() {
        captureTheQuiz(in: "largest-dark", extra: GalleryLayoutUITests.largestTextSize + ["--appearance-dark"])
    }

    @MainActor
    func testOfflineInBothAppearances() {
        for (appearance, extra) in [("light", ["--appearance-light"]), ("dark", ["--appearance-dark"])] {
            let app = openQuiz(extra: FakeQuizLaunch.offline + extra)
            pick(app, choice: 0, waitFor: "cooking-quiz-problem")
            attachScreenshot(of: app, named: "quiz-offline-" + appearance)
            app.terminate()
        }
    }

    @MainActor private func captureTheQuiz(in appearance: String, extra: [String]) {
        let app = openQuiz(extra: FakeQuizLaunch.arguments + extra)
        app.buttons["cooking-quiz-choice-1"].tap()
        settle()
        attachScreenshot(of: app, named: "quiz-question-" + appearance)
        app.buttons["cooking-quiz-check"].tap()
        showResult(app, identifier: "cooking-quiz-verdict")
        attachScreenshot(of: app, named: "quiz-wrong-" + appearance)
        pick(app, choice: 0, waitFor: "cooking-quiz-next")
        attachScreenshot(of: app, named: "quiz-right-" + appearance)
    }

    @MainActor private func openQuiz(extra: [String]) -> XCUIApplication {
        let (app, _) = cookingIntroduction(extra: extra)
        beginAndWalkAllSteps(app)
        app.buttons["cooking-quiz-open"].tap()
        XCTAssertTrue(app.element("cooking-quiz-question").waitForExistence(timeout: 5))
        return app
    }

    /// Ticks and checks a choice, then scrolls to the result so the picture shows it with the question's choices.
    @MainActor private func pick(_ app: XCUIApplication, choice: Int, waitFor identifier: String) {
        app.buttons["cooking-quiz-choice-" + String(choice)].tap()
        app.buttons["cooking-quiz-check"].tap()
        showResult(app, identifier: identifier)
    }

    @MainActor private func showResult(_ app: XCUIApplication, identifier: String) {
        XCTAssertTrue(app.element(identifier).waitForExistence(timeout: 5))
        app.swipeUp()
        settle()
    }

    @MainActor private func settle() {
        Thread.sleep(forTimeInterval: 1)
    }
}
