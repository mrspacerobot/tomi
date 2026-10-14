import XCTest

/// A new cook, end to end against the fake server: sign in, answer the first questions, scan the fridge,
/// confirm what is there, pick tonight's special and cook it to the end.
final class FirstEveningUITests: XCTestCase {
    override func setUp() {
        continueAfterFailure = false
    }

    @MainActor
    func testANewCookSignsInAnswersScansAndCooksTonightsSpecial() {
        let app = XCUIApplication.launched(XCUIApplication.newCook)
        signIn(app)
        answerTheFirstQuestions(app)
        scanTheFridge(app)
        cookTheSpecial(app)
        XCTAssertTrue(app.staticTexts["welcome-xp"].waitForExistence(timeout: 5))
        XCTAssertNotEqual(app.staticTexts["welcome-xp"].label, "0 XP")
    }

    @MainActor private func signIn(_ app: XCUIApplication) {
        XCTAssertTrue(app.buttons["sign-in-fake"].waitForExistence(timeout: 5))
        app.buttons["sign-in-fake"].tap()
    }

    @MainActor private func answerTheFirstQuestions(_ app: XCUIApplication) {
        XCTAssertTrue(app.element("question-diet").waitForExistence(timeout: 5))
        app.element("choice-fake-veg").tap()
        app.buttons["onboarding-next"].tap()
        app.element("choice-fake-nuts").tap()
        while app.buttons["onboarding-next"].exists {
            app.buttons["onboarding-next"].tap()
        }
        app.buttons["onboarding-done"].tap()
        XCTAssertTrue(app.buttons["home-scan"].waitForExistence(timeout: 5))
    }

    @MainActor private func scanTheFridge(_ app: XCUIApplication) {
        app.buttons["home-scan"].tap()
        XCTAssertTrue(app.buttons["scan-pick-photo"].waitForExistence(timeout: 5))
        app.buttons["scan-pick-photo"].tap()
        XCTAssertTrue(app.element("confirm-title").waitForExistence(timeout: 5))
        app.buttons["confirm-find"].tap()
    }

    @MainActor private func cookTheSpecial(_ app: XCUIApplication) {
        let cook = app.buttons.matching(NSPredicate(format: "identifier BEGINSWITH 'offer-cook-'")).firstMatch
        XCTAssertTrue(cook.waitForExistence(timeout: 5))
        cook.tap()
        XCTAssertTrue(app.element("player-title").waitForExistence(timeout: 5))
        while !app.element("player-answer-0").exists {
            app.buttons["player-next"].tap()
        }
        app.element("player-answer-0").tap()
        app.buttons["player-finish"].tap()
    }
}
