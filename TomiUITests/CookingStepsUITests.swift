import XCTest

final class CookingStepsUITests: XCTestCase {
    override func setUp() { continueAfterFailure = false }

    @MainActor
    func testTheCookWalksEveryStepAndLeavesFromTheLastOne() {
        let (app, identifier) = cookingIntroduction()
        beginSteps(app)
        XCTAssertTrue(progress(app, "Step 1 of 3").waitForExistence(timeout: 5))
        XCTAssertFalse(app.buttons["cooking-step-previous"].exists)
        walkToTheLastStep(app)
        XCTAssertFalse(app.buttons["cooking-step-next"].exists)
        leaveAfterTheLastStep(app, identifier: identifier)
    }

    @MainActor
    func testGoingBackShowsTheStepBefore() {
        let (app, _) = cookingIntroduction()
        beginSteps(app)
        app.buttons["cooking-step-next"].tap()
        app.buttons["cooking-step-previous"].tap()
        XCTAssertTrue(progress(app, "Step 1 of 3").waitForExistence(timeout: 5))
    }

    @MainActor
    func testTheStepsDoNotBeginWhenRestrictionsChangedSincePreparation() {
        let (app, _) = cookingIntroduction(extra: ["--fake-profile-refresh-changes-late"])
        app.buttons["cooking-start"].tap()
        XCTAssertTrue(app.buttons["cooking-steps-begin"].waitForExistence(timeout: 5))
        app.buttons["cooking-steps-begin"].tap()
        refuseAndStartOver(app)
    }

    @MainActor private func refuseAndStartOver(_ app: XCUIApplication) {
        XCTAssertTrue(app.alerts.staticTexts["Please check tonight's dishes again"].waitForExistence(timeout: 5))
        app.alerts.buttons["OK"].tap()
        XCTAssertTrue(app.buttons["home-scan"].waitForExistence(timeout: 5))
        XCTAssertFalse(app.buttons["cooking-step-next"].exists)
    }

    /// The progress line is shown in capitals, so VoiceOver and the tests read it in capitals.
    @MainActor private func progress(_ app: XCUIApplication, _ words: String) -> XCUIElement {
        app.staticTexts.matching(NSPredicate(format: "label =[c] %@", words)).firstMatch
    }

    @MainActor private func beginSteps(_ app: XCUIApplication) {
        app.buttons["cooking-start"].tap()
        XCTAssertTrue(app.buttons["cooking-steps-begin"].waitForExistence(timeout: 5))
        app.buttons["cooking-steps-begin"].tap()
        XCTAssertTrue(app.element("cooking-steps").waitForExistence(timeout: 5))
    }

    @MainActor private func walkToTheLastStep(_ app: XCUIApplication) {
        app.buttons["cooking-step-next"].tap()
        XCTAssertTrue(
            app.staticTexts.matching(NSPredicate(format: "label BEGINSWITH %@", "Melt most of the butter")).firstMatch
                .waitForExistence(timeout: 5)
        )
        XCTAssertTrue(app.buttons["cooking-step-previous"].exists)
        assertTheTimeIsNotUnderTheButton(app)
        app.buttons["cooking-step-next"].tap()
        XCTAssertTrue(progress(app, "Step 3 of 3").waitForExistence(timeout: 5))
    }

    @MainActor private func leaveAfterTheLastStep(_ app: XCUIApplication, identifier: String) {
        app.buttons["cooking-steps-finish"].tap()
        XCTAssertTrue(app.element("suggestion-detail").waitForExistence(timeout: 5))
        let recipeID = identifier.replacingOccurrences(of: "suggestion-open-", with: "")
        XCTAssertTrue(app.element("suggestion-title-" + recipeID).exists)
    }

    /// A step's time is part of the step, so it must sit above the buttons and never be covered by one.
    @MainActor private func assertTheTimeIsNotUnderTheButton(_ app: XCUIApplication) {
        let time = app.staticTexts.matching(NSPredicate(format: "label CONTAINS 'min'")).firstMatch
        XCTAssertTrue(time.waitForExistence(timeout: 5))
        XCTAssertFalse(time.frame.intersects(app.buttons["cooking-step-next"].frame))
    }
}
