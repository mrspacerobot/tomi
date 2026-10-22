import XCTest

/// Tonight's special and its alternatives from the graph, against the fake server: what the menu shows,
/// and the detail with the recipe already adapted for the cook and what changed.
final class SuggestionsUITests: XCTestCase {
    private static let insteadOf = " instead of "

    override func setUp() {
        continueAfterFailure = false
    }

    @MainActor
    func testTheMenuShowsTheSpecialAndItsAlternatives() {
        let app = findTonightsMenu()
        let titles = app.staticTexts.matching(NSPredicate(format: "identifier BEGINSWITH 'suggestion-title-'"))
        XCTAssertTrue(titles.firstMatch.waitForExistence(timeout: 5))
        XCTAssertGreaterThan(titles.count, 1)
        XCTAssertTrue(app.element("suggestion-checked").exists)
        XCTAssertTrue(app.element("suggestion-missing").exists)
    }

    @MainActor
    func testTheDetailShowsTheAdaptedRecipeAndNoOriginal() {
        let app = findTonightsMenu()
        openSuggestion(app, at: 0)
        XCTAssertTrue(app.element("suggestion-yield").waitForExistence(timeout: 5))
        scroll(app, to: app.element("suggestion-step-1"))
        scroll(app, to: app.element("suggestion-swap"))
        XCTAssertFalse(app.element("suggestion-original").exists)
    }

    @MainActor
    func testASwapShowsTheStandInInTheStepsAndInWhatChanged() {
        let app = findTonightsMenu()
        openSuggestion(app, at: 0)
        scroll(app, to: app.element("suggestion-swap"))
        let words = app.element("suggestion-swap").label.components(separatedBy: Self.insteadOf)
        XCTAssertEqual(words.count, 2)
        XCTAssertTrue(stepLabels(app).contains { $0.localizedCaseInsensitiveContains(words[0]) })
        XCTAssertFalse(stepLabels(app).contains { $0.localizedCaseInsensitiveContains(words[1]) })
    }

    @MainActor
    func testALeftOutPartShowsInWhatChangedAndItsStepIsAbsent() {
        let app = findTonightsMenu()
        openSuggestion(app, at: 1)
        scroll(app, to: app.element("suggestion-left-out"))
        let name = app.element("suggestion-left-out").label.components(separatedBy: ": ").last ?? ""
        XCTAssertFalse(name.isEmpty)
        XCTAssertFalse(stepLabels(app).isEmpty)
        XCTAssertFalse(stepLabels(app).contains { $0.localizedCaseInsensitiveContains(name) })
    }

    /// The labels of the numbered steps of the recipe on the detail screen.
    @MainActor private func stepLabels(_ app: XCUIApplication) -> [String] {
        let steps = app.descendants(matching: .any).matching(
            NSPredicate(format: "identifier BEGINSWITH 'suggestion-step-'")
        )
        return steps.allElementsBoundByIndex.map(\.label)
    }

    @MainActor private func openSuggestion(_ app: XCUIApplication, at position: Int) {
        let buttons = app.buttons.matching(NSPredicate(format: "identifier BEGINSWITH 'suggestion-open-'"))
        XCTAssertTrue(buttons.firstMatch.waitForExistence(timeout: 5))
        scroll(app, to: buttons.element(boundBy: position))
        buttons.element(boundBy: position).tap()
    }

    @MainActor private func scroll(_ app: XCUIApplication, to element: XCUIElement) {
        for _ in 0..<8 where !element.exists || !element.isHittable {
            app.swipeUp()
        }
        XCTAssertTrue(element.waitForExistence(timeout: 5))
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
