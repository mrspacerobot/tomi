import XCTest

/// The way into the cooking screens that every cooking UI test shares: the fake server, a returning cook, tonight's
/// special, and its introduction.
extension XCTestCase {
    @MainActor func cookingIntroduction(
        store: String = "--store-in-memory",
        extra: [String] = []
    ) -> (XCUIApplication, String) {
        let app = XCUIApplication.launched(
            XCUIApplication.returningCook + [store, "--fake-guided-cooking"] + extra
        )
        enterCookingMenu(app)
        return openIntroduction(app)
    }

    @MainActor func enterCookingMenu(_ app: XCUIApplication) {
        app.buttons["home-scan"].tap()
        app.buttons["scan-type-instead"].tap()
        app.buttons["confirm-find"].tap()
    }

    /// Starts preparation, begins the steps and walks to the last of the guided suggestion's three steps.
    @MainActor func beginAndWalkAllSteps(_ app: XCUIApplication) {
        app.buttons["cooking-start"].tap()
        XCTAssertTrue(app.buttons["cooking-steps-begin"].waitForExistence(timeout: 5))
        app.buttons["cooking-steps-begin"].tap()
        XCTAssertTrue(app.buttons["cooking-step-next"].waitForExistence(timeout: 5))
        app.buttons["cooking-step-next"].tap()
        app.buttons["cooking-step-next"].tap()
    }

    @MainActor func attachScreenshot(of app: XCUIApplication, named name: String) {
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }

    @MainActor private func openIntroduction(_ app: XCUIApplication) -> (XCUIApplication, String) {
        let suggestion = app.buttons.matching(NSPredicate(format: "identifier BEGINSWITH 'suggestion-open-'"))
            .firstMatch
        XCTAssertTrue(suggestion.waitForExistence(timeout: 5))
        let identifier = suggestion.identifier
        suggestion.tap()
        app.buttons["cooking-introduction-open"].tap()
        return (app, identifier)
    }
}
