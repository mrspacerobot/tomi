import XCTest

/// A new cook, end to end against the fake server: sign in, answer the first questions, scan the fridge,
/// confirm what is there and open tonight's special from the graph. Cooking a graph recipe is not built yet.
final class FirstEveningUITests: XCTestCase {
    override func setUp() {
        continueAfterFailure = false
    }

    @MainActor
    func testANewCookSignsInAnswersScansAndOpensTonightsSpecial() {
        let app = XCUIApplication.launched(XCUIApplication.newCook)
        signIn(app)
        answerTheFirstQuestions(app)
        scanTheFridge(app)
        openTheSpecial(app)
    }

    @MainActor private func signIn(_ app: XCUIApplication) {
        XCTAssertTrue(app.buttons["sign-in-fake"].waitForExistence(timeout: 5))
        app.buttons["sign-in-fake"].tap()
        XCTAssertTrue(app.buttons["onboarding-start"].waitForExistence(timeout: 5))
        app.buttons["onboarding-start"].tap()
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

    @MainActor private func openTheSpecial(_ app: XCUIApplication) {
        let open = app.buttons.matching(NSPredicate(format: "identifier BEGINSWITH 'offer-open-'")).firstMatch
        XCTAssertTrue(open.waitForExistence(timeout: 5))
        open.tap()
        XCTAssertTrue(app.element("offer-plan").waitForExistence(timeout: 5))
    }
}
