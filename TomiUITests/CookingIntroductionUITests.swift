import XCTest

final class CookingIntroductionUITests: XCTestCase {
    override func setUp() { continueAfterFailure = false }

    @MainActor
    func testIntroductionPreparationAndReturnToTheSameSuggestion() {
        let app = introductionApp()
        XCTAssertTrue(app.staticTexts["A clear cue"].waitForExistence(timeout: 5))
        let original = suggestionTitle(app).identifier
        capture(app, named: "introduction-light")
        showPreparation(app, screenshot: "preparation-light")
        returnToSuggestion(app, identifier: original)
    }

    @MainActor
    func testIntroductionAndPreparationAtLargestTextInDarkAppearance() {
        let arguments = GalleryLayoutUITests.largestTextSize + ["--appearance-dark"]
        let app = introductionApp(extra: arguments)
        XCTAssertTrue(app.staticTexts["A clear cue"].waitForExistence(timeout: 5))
        capture(app, named: "introduction-dark-largest-text")
        showPreparation(app, screenshot: "preparation-dark-largest-text")
    }

    @MainActor
    func testStartRefusesWhenFreshProfileReadFails() {
        let app = introductionApp(extra: ["--fake-profile-refresh-fails"])
        refuseStart(app)
    }

    @MainActor
    func testStartRefusesWhenRestrictionsChanged() {
        let app = introductionApp(extra: ["--fake-profile-refresh-changes"])
        refuseStart(app)
    }

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
        XCTAssertEqual(suggestionTitle(app).identifier, identifier)
    }

    @MainActor private func suggestionTitle(_ app: XCUIApplication) -> XCUIElement {
        app.staticTexts.matching(NSPredicate(format: "identifier BEGINSWITH 'suggestion-title-'"))
            .firstMatch
    }

    @MainActor private func capture(_ app: XCUIApplication, named name: String) {
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }

    @MainActor private func introductionApp(extra: [String] = []) -> XCUIApplication {
        let app = XCUIApplication.launched(
            XCUIApplication.returningCook + ["--store-in-memory", "--fake-guided-cooking"] + extra
        )
        app.buttons["home-scan"].tap()
        app.buttons["scan-type-instead"].tap()
        app.buttons["confirm-find"].tap()
        app.buttons.matching(NSPredicate(format: "identifier BEGINSWITH 'suggestion-open-'"))
            .firstMatch.tap()
        app.buttons["cooking-introduction-open"].tap()
        return app
    }
}
