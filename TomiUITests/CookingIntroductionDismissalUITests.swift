import XCTest

final class CookingIntroductionDismissalUITests: XCTestCase {
    @MainActor
    func testDismissingDuringProfileRefreshDoesNotOpenPreparationLater() {
        let app = introductionApp()
        app.buttons["cooking-start"].tap()
        XCTAssertFalse(app.buttons["cooking-start"].isEnabled)
        app.buttons["cooking-not-tonight"].tap()
        rescanAfterDismissal(app)
        let suggestion = app.buttons.matching(NSPredicate(format: "identifier BEGINSWITH 'suggestion-open-'"))
            .firstMatch
        XCTAssertTrue(suggestion.waitForExistence(timeout: 5))
        XCTAssertFalse(app.element("cooking-steps-unavailable").exists)
    }

    @MainActor private func rescanAfterDismissal(_ app: XCUIApplication) {
        app.navigationBars.buttons.firstMatch.tap()
        app.navigationBars.buttons.firstMatch.tap()
        app.buttons["home-scan"].tap()
        app.buttons["scan-pick-photo"].tap()
        XCTAssertTrue(app.buttons["confirm-find"].waitForExistence(timeout: 5))
        app.buttons["confirm-find"].tap()
    }

    @MainActor private func introductionApp() -> XCUIApplication {
        let arguments =
            XCUIApplication.returningCook + [
                "--store-in-memory", "--fake-guided-cooking", "--fake-profile-refresh-waits",
            ]
        let app = XCUIApplication.launched(arguments)
        enterMenu(app)
        openIntroduction(app)
        return app
    }

    @MainActor private func enterMenu(_ app: XCUIApplication) {
        app.buttons["home-scan"].tap()
        app.buttons["scan-type-instead"].tap()
        app.buttons["confirm-find"].tap()
    }

    @MainActor private func openIntroduction(_ app: XCUIApplication) {
        app.buttons.matching(NSPredicate(format: "identifier BEGINSWITH 'suggestion-open-'"))
            .firstMatch.tap()
        app.buttons["cooking-introduction-open"].tap()
    }
}
