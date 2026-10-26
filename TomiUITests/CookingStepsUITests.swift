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

    @MainActor
    func testTheStepsAtLargestTextInDarkAppearance() {
        let arguments = GalleryLayoutUITests.largestTextSize + ["--appearance-dark"]
        let (app, _) = cookingIntroduction(extra: arguments)
        beginSteps(app)
        XCTAssertTrue(app.buttons["cooking-step-next"].waitForExistence(timeout: 5))
        attachScreenshot(of: app, named: "steps-largest-dark")
    }

    @MainActor
    func testTheStepScreenInLightAndDarkAppearance() {
        for appearance in [[], ["--appearance-dark"]] {
            let (app, _) = cookingIntroduction(extra: appearance)
            beginSteps(app)
            app.buttons["cooking-step-next"].tap()
            attachScreenshot(of: app, named: "steps-middle-" + (appearance.isEmpty ? "light" : "dark"))
            app.terminate()
        }
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
        app.buttons["cooking-step-next"].tap()
        XCTAssertTrue(progress(app, "Step 3 of 3").waitForExistence(timeout: 5))
    }

    @MainActor private func leaveAfterTheLastStep(_ app: XCUIApplication, identifier: String) {
        app.buttons["cooking-steps-finish"].tap()
        XCTAssertTrue(app.element("suggestion-detail").waitForExistence(timeout: 5))
        let recipeID = identifier.replacingOccurrences(of: "suggestion-open-", with: "")
        XCTAssertTrue(app.element("suggestion-title-" + recipeID).exists)
    }
}
