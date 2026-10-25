import XCTest

final class CookingIntroductionUITests: XCTestCase {
    override func setUp() { continueAfterFailure = false }

    @MainActor
    func testIntroductionPreparationAndReturnToTheSameSuggestion() {
        let (app, identifier) = introductionApp()
        XCTAssertTrue(app.staticTexts["Gentle curds"].waitForExistence(timeout: 5))
        capture(app, named: "introduction-light")
        captureFooter(app, named: "introduction-light-footer")
        showPreparation(app, screenshot: "preparation-light")
        returnToSuggestion(app, identifier: identifier)
    }

    @MainActor
    func testIntroductionAndPreparationAtLargestTextInDarkAppearance() {
        let arguments = GalleryLayoutUITests.largestTextSize + ["--appearance-dark"]
        let (app, _) = introductionApp(extra: arguments)
        XCTAssertTrue(app.staticTexts["Gentle curds"].waitForExistence(timeout: 5))
        capture(app, named: "introduction-dark-largest-text")
        showPreparation(app, screenshot: "preparation-dark-largest-text")
    }

    @MainActor
    func testIntroductionAndPreparationInDarkAppearance() {
        let (app, _) = introductionApp(extra: ["--appearance-dark"])
        XCTAssertTrue(app.staticTexts["Gentle curds"].waitForExistence(timeout: 5))
        capture(app, named: "introduction-dark")
        captureFooter(app, named: "introduction-dark-footer")
        app.buttons["cooking-start"].tap()
        XCTAssertTrue(app.element("cooking-steps-unavailable").waitForExistence(timeout: 5))
        capture(app, named: "preparation-dark")
        captureFooter(app, named: "preparation-dark-footer")
    }

    @MainActor
    func testStartRefusesWhenFreshProfileReadFails() {
        let (app, _) = introductionApp(extra: ["--fake-profile-refresh-fails"])
        refuseStart(app)
    }

    @MainActor
    func testStartRefusesWhenRestrictionsChanged() {
        let (app, _) = introductionApp(extra: ["--fake-profile-refresh-changes"])
        refuseStart(app)
    }

}

extension CookingIntroductionUITests {
    @MainActor private func refuseStart(_ app: XCUIApplication) {
        app.buttons["cooking-start"].tap()
        XCTAssertTrue(app.alerts.staticTexts["Please check tonight's dishes again"].waitForExistence(timeout: 5))
        XCTAssertFalse(app.element("cooking-steps-unavailable").exists)
    }

    @MainActor private func showPreparation(_ app: XCUIApplication, screenshot: String) {
        app.buttons["cooking-start"].tap()
        XCTAssertTrue(app.element("cooking-steps-unavailable").waitForExistence(timeout: 5))
        if screenshot == "preparation-light" { checkIngredientToggle(app) }
        capture(app, named: screenshot)
        if screenshot == "preparation-light" { captureFooter(app, named: "preparation-light-footer") }
    }

    @MainActor private func checkIngredientToggle(_ app: XCUIApplication) {
        let ingredient = app.buttons.matching(
            NSPredicate(format: "identifier BEGINSWITH 'preparation-ingredient-'")
        ).firstMatch
        XCTAssertFalse(ingredient.isSelected)
        ingredient.tap()
        XCTAssertTrue(ingredient.isSelected)
    }

    @MainActor private func returnToSuggestion(_ app: XCUIApplication, identifier: String) {
        app.buttons["cooking-return-to-suggestion"].tap()
        XCTAssertTrue(app.element("suggestion-detail").waitForExistence(timeout: 5))
        let recipeID = identifier.replacingOccurrences(of: "suggestion-open-", with: "")
        XCTAssertTrue(app.element("suggestion-title-" + recipeID).exists)
    }

    @MainActor private func capture(_ app: XCUIApplication, named name: String) {
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }

    @MainActor private func captureFooter(_ app: XCUIApplication, named name: String) {
        app.swipeUp()
        app.swipeUp()
        capture(app, named: name)
    }

    @MainActor private func introductionApp(extra: [String] = []) -> (XCUIApplication, String) {
        let app = XCUIApplication.launched(
            XCUIApplication.returningCook + ["--store-in-memory", "--fake-guided-cooking"] + extra
        )
        enterMenu(app)
        return openIntroduction(app)
    }

    @MainActor private func enterMenu(_ app: XCUIApplication) {
        app.buttons["home-scan"].tap()
        app.buttons["scan-type-instead"].tap()
        app.buttons["confirm-find"].tap()
    }

    @MainActor private func openIntroduction(_ app: XCUIApplication) -> (XCUIApplication, String) {
        let suggestion = app.buttons.matching(NSPredicate(format: "identifier BEGINSWITH 'suggestion-open-'"))
            .firstMatch
        let identifier = suggestion.identifier
        suggestion.tap()
        app.buttons["cooking-introduction-open"].tap()
        return (app, identifier)
    }
}
