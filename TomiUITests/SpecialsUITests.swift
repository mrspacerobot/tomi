import XCTest

/// Tonight's special and its alternatives from the graph, against the fake server: what the menu shows,
/// and the detail with the safe plan beside the graph's own recipe.
final class SpecialsUITests: XCTestCase {
    override func setUp() {
        continueAfterFailure = false
    }

    @MainActor
    func testTheMenuShowsTheSpecialAndItsAlternatives() {
        let app = findTonightsMenu()
        let titles = app.staticTexts.matching(NSPredicate(format: "identifier BEGINSWITH 'offer-title-'"))
        XCTAssertTrue(titles.firstMatch.waitForExistence(timeout: 5))
        XCTAssertGreaterThan(titles.count, 1)
        XCTAssertTrue(app.element("offer-checked").exists)
        XCTAssertTrue(app.element("offer-missing").exists)
    }

    @MainActor
    func testTheDetailShowsTheSafePlanBesideTheOriginalRecipe() {
        let app = findTonightsMenu()
        let open = app.buttons.matching(NSPredicate(format: "identifier BEGINSWITH 'offer-open-'")).firstMatch
        XCTAssertTrue(open.waitForExistence(timeout: 5))
        open.tap()
        XCTAssertTrue(app.element("offer-plan").waitForExistence(timeout: 5))
        app.swipeUp()
        XCTAssertTrue(app.element("offer-source").waitForExistence(timeout: 5))
        scrollToFirstStep(app)
    }

    @MainActor private func scrollToFirstStep(_ app: XCUIApplication) {
        let step = app.staticTexts.matching(NSPredicate(format: "label BEGINSWITH[c] 'Step 1'")).firstMatch
        for _ in 0..<4 where !step.exists {
            app.swipeUp()
        }
        XCTAssertTrue(step.waitForExistence(timeout: 5))
    }

    @MainActor
    func testTheOriginalRecipeIsNeverCalledAdapted() {
        let app = findTonightsMenu()
        app.buttons.matching(NSPredicate(format: "identifier BEGINSWITH 'offer-open-'")).firstMatch.tap()
        XCTAssertTrue(app.element("offer-source").waitForExistence(timeout: 5))
        let adapted = NSPredicate(format: "label CONTAINS[c] 'adapted'")
        XCTAssertFalse(app.staticTexts.containing(adapted).firstMatch.exists)
    }

    /// Opens the fridge scan, types instead of taking a photo, and asks for tonight's special.
    @MainActor private func findTonightsMenu() -> XCUIApplication {
        let app = XCUIApplication.launched(XCUIApplication.returningCook + ["--store-in-memory"])
        XCTAssertTrue(app.buttons["home-scan"].waitForExistence(timeout: 5))
        app.buttons["home-scan"].tap()
        XCTAssertTrue(app.buttons["scan-type-instead"].waitForExistence(timeout: 5))
        app.buttons["scan-type-instead"].tap()
        XCTAssertTrue(app.buttons["confirm-find"].waitForExistence(timeout: 5))
        app.buttons["confirm-find"].tap()
        return app
    }
}
