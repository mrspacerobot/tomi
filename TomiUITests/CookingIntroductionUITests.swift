import XCTest

final class CookingIntroductionUITests: XCTestCase {
    override func setUp() { continueAfterFailure = false }

    @MainActor
    func testIntroductionPreparationAndReturnToTheSameSuggestion() {
        let (app, identifier) = cookingIntroduction()
        XCTAssertTrue(app.staticTexts["Gentle curds"].waitForExistence(timeout: 5))
        attachScreenshot(of: app, named: "introduction-light")
        captureFooter(app, named: "introduction-light-footer")
        showPreparation(app, screenshot: "preparation-light")
        returnToSuggestion(app, identifier: identifier)
    }

    @MainActor
    func testIntroductionAndPreparationAtLargestTextInDarkAppearance() {
        let arguments = GalleryLayoutUITests.largestTextSize + ["--appearance-dark"]
        let (app, _) = cookingIntroduction(extra: arguments)
        XCTAssertTrue(app.staticTexts["Gentle curds"].waitForExistence(timeout: 5))
        attachScreenshot(of: app, named: "introduction-dark-largest-text")
        showPreparation(app, screenshot: "preparation-dark-largest-text")
    }

    @MainActor
    func testIntroductionAndPreparationInDarkAppearance() {
        let (app, _) = cookingIntroduction(extra: ["--appearance-dark"])
        XCTAssertTrue(app.staticTexts["Gentle curds"].waitForExistence(timeout: 5))
        attachScreenshot(of: app, named: "introduction-dark")
        captureFooter(app, named: "introduction-dark-footer")
        app.buttons["cooking-start"].tap()
        XCTAssertTrue(app.buttons["cooking-steps-begin"].waitForExistence(timeout: 5))
        attachScreenshot(of: app, named: "preparation-dark")
        captureFooter(app, named: "preparation-dark-footer")
    }

    @MainActor
    func testStartRefusesWhenFreshProfileReadFails() {
        let (app, _) = cookingIntroduction(extra: ["--fake-profile-refresh-fails"])
        refuseStart(app, screenshot: "refusal-refresh-failed-light")
    }

    @MainActor
    func testStartRefusesWhenFreshProfileReadFailsInDarkAppearance() {
        let (app, _) = cookingIntroduction(extra: ["--fake-profile-refresh-fails", "--appearance-dark"])
        refuseStart(app, screenshot: "refusal-refresh-failed-dark")
    }

    @MainActor
    func testStartRefusesWhenRestrictionsChanged() {
        let (app, _) = cookingIntroduction(extra: ["--fake-profile-refresh-changes"])
        refuseStart(app, screenshot: "refusal-restrictions-changed-light")
    }

    @MainActor
    func testStartRefusesWhenRestrictionsChangedInDarkAppearance() {
        let (app, _) = cookingIntroduction(extra: ["--fake-profile-refresh-changes", "--appearance-dark"])
        refuseStart(app, screenshot: "refusal-restrictions-changed-dark")
    }

    @MainActor
    func testRecipeDetailOffersNoIntroductionWhenTeachingIsUnavailable() {
        showUnavailableTeaching(extra: [], screenshot: "teaching-unavailable-light")
    }

    @MainActor
    func testRecipeDetailOffersNoIntroductionWhenTeachingIsUnavailableInDarkAppearance() {
        showUnavailableTeaching(extra: ["--appearance-dark"], screenshot: "teaching-unavailable-dark")
    }
}

extension CookingIntroductionUITests {
    @MainActor private func showUnavailableTeaching(extra: [String], screenshot: String) {
        let app = XCUIApplication.launched(XCUIApplication.returningCook + ["--store-in-memory"] + extra)
        enterCookingMenu(app)
        app.buttons.matching(NSPredicate(format: "identifier BEGINSWITH 'suggestion-open-'")).firstMatch.tap()
        XCTAssertTrue(app.element("suggestion-detail").waitForExistence(timeout: 5))
        XCTAssertFalse(app.buttons["cooking-introduction-open"].exists)
        attachScreenshot(of: app, named: screenshot)
    }

    @MainActor private func refuseStart(_ app: XCUIApplication, screenshot: String) {
        app.buttons["cooking-start"].tap()
        XCTAssertTrue(app.alerts.staticTexts["Please check tonight's dishes again"].waitForExistence(timeout: 5))
        attachScreenshot(of: app, named: screenshot)
        XCTAssertFalse(app.buttons["cooking-steps-begin"].exists)
        app.alerts.buttons["OK"].tap()
        XCTAssertTrue(app.buttons["home-scan"].waitForExistence(timeout: 5))
        XCTAssertFalse(app.buttons["cooking-start"].exists)
    }

    @MainActor private func showPreparation(_ app: XCUIApplication, screenshot: String) {
        app.buttons["cooking-start"].tap()
        XCTAssertTrue(app.buttons["cooking-steps-begin"].waitForExistence(timeout: 5))
        if screenshot == "preparation-light" { checkIngredientToggle(app) }
        attachScreenshot(of: app, named: screenshot)
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

    @MainActor private func captureFooter(_ app: XCUIApplication, named name: String) {
        app.swipeUp()
        app.swipeUp()
        attachScreenshot(of: app, named: name)
    }
}
