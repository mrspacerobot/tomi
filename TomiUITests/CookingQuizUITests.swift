import XCTest

/// The quiz after the steps, answered by the fake server from the invented quiz: one question at a time, a wrong
/// pick tried again, the server's explanation once right, and carrying on without it offline.
final class CookingQuizUITests: XCTestCase {
    override func setUp() {
        continueAfterFailure = false
        XCTAssertFalse(FakeQuizLaunch.arguments.isEmpty, "The invented quiz fixture is missing from the UI tests.")
    }

    @MainActor
    func testTheCookAnswersWrongThenRightAndReachesTheEndOfTheQuiz() {
        let (app, identifier) = cookingIntroduction(extra: FakeQuizLaunch.arguments)
        openTheQuiz(app)
        answerTheFirstQuestionWrongThenRight(app)
        app.buttons["cooking-quiz-next"].tap()
        answerTheLastQuestionRight(app)
        XCTAssertTrue(app.element("cooking-quiz-done").waitForExistence(timeout: 5))
        app.buttons["cooking-quiz-finish"].tap()
        assertBackAtTheRecipe(app, identifier: identifier)
    }

    @MainActor
    func testOfflineTheQuizSaysItNeedsAConnectionAndTheCookCarriesOn() {
        let (app, identifier) = cookingIntroduction(extra: FakeQuizLaunch.offline)
        openTheQuiz(app)
        pick(app, choice: 0)
        XCTAssertTrue(app.element("cooking-quiz-problem").waitForExistence(timeout: 5))
        XCTAssertTrue(app.element("cooking-quiz-problem").label.contains("The quiz needs a connection."))
        XCTAssertFalse(app.element("cooking-quiz-verdict").exists)
        app.buttons["cooking-quiz-skip"].tap()
        assertBackAtTheRecipe(app, identifier: identifier)
    }

    /// The graph moved on: the pick cannot be checked again, so the only way on is to carry on without the quiz.
    @MainActor
    func testAfterTheGraphChangedTheQuizCannotBeCheckedAgainAndTheCookCarriesOn() {
        let (app, identifier) = cookingIntroduction(extra: FakeQuizLaunch.graphChanged)
        openTheQuiz(app)
        pick(app, choice: 0)
        XCTAssertTrue(app.element("cooking-quiz-problem").waitForExistence(timeout: 5))
        XCTAssertFalse(app.buttons["cooking-quiz-check"].exists)
        XCTAssertFalse(app.element("cooking-quiz-verdict").exists)
        app.buttons["cooking-quiz-skip"].tap()
        assertBackAtTheRecipe(app, identifier: identifier)
    }

    /// Nothing can be checked before a choice is ticked; a wrong pick is struck out and says so in words, with no
    /// explanation; the right one then shows the server's explanation.
    @MainActor private func answerTheFirstQuestionWrongThenRight(_ app: XCUIApplication) {
        XCTAssertTrue(question(app, "Which tool does Tomi's test kitchen stir with?").waitForExistence(timeout: 5))
        XCTAssertFalse(app.buttons["cooking-quiz-check"].isEnabled)
        pick(app, choice: 1)
        assertWrongWithoutExplanation(app, choice: 1)
        pick(app, choice: 0)
        XCTAssertTrue(app.element("cooking-quiz-verdict").label.contains("Right."))
        XCTAssertTrue(app.element("cooking-quiz-verdict").label.contains("Tomi stirs with a wooden spoon."))
        XCTAssertTrue(app.buttons["cooking-quiz-choice-0"].isSelected)
    }

    @MainActor private func assertWrongWithoutExplanation(_ app: XCUIApplication, choice: Int) {
        XCTAssertTrue(app.element("cooking-quiz-verdict").waitForExistence(timeout: 5))
        XCTAssertTrue(app.element("cooking-quiz-verdict").label.contains("Not quite."))
        XCTAssertTrue(app.buttons["cooking-quiz-choice-" + String(choice)].label.contains("Not right"))
        XCTAssertFalse(app.element("cooking-quiz-verdict").label.contains("wooden spoon"))
        XCTAssertFalse(app.buttons["cooking-quiz-next"].exists)
    }

    @MainActor private func answerTheLastQuestionRight(_ app: XCUIApplication) {
        XCTAssertTrue(question(app, "What rings when the test kitchen's timer ends?").waitForExistence(timeout: 5))
        pick(app, choice: 1)
        XCTAssertTrue(app.element("cooking-quiz-verdict").waitForExistence(timeout: 5))
        XCTAssertTrue(app.element("cooking-quiz-verdict").label.contains("small bell"))
        app.buttons["cooking-quiz-next"].tap()
    }

    @MainActor private func pick(_ app: XCUIApplication, choice: Int) {
        app.buttons["cooking-quiz-choice-" + String(choice)].tap()
        app.buttons["cooking-quiz-check"].tap()
    }

    @MainActor private func question(_ app: XCUIApplication, _ words: String) -> XCUIElement {
        app.staticTexts[words]
    }

    @MainActor private func openTheQuiz(_ app: XCUIApplication) {
        beginAndWalkAllSteps(app)
        app.buttons["cooking-quiz-open"].tap()
        XCTAssertTrue(app.element("cooking-quiz").waitForExistence(timeout: 5))
    }

    @MainActor private func assertBackAtTheRecipe(_ app: XCUIApplication, identifier: String) {
        XCTAssertTrue(app.element("suggestion-detail").waitForExistence(timeout: 5))
        let recipeID = identifier.replacingOccurrences(of: "suggestion-open-", with: "")
        XCTAssertTrue(app.element("suggestion-title-" + recipeID).exists)
    }
}
