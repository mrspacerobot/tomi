import XCTest

/// A suggestion whose teaching has no quiz goes from the last step straight back to the recipe.
final class CookingNoQuizUITests: XCTestCase {
    override func setUp() { continueAfterFailure = false }

    @MainActor
    func testASuggestionWithNoQuizGoesStraightPastIt() {
        let (app, identifier) = cookingIntroduction()
        beginAndWalkAllSteps(app)
        XCTAssertFalse(app.buttons["cooking-quiz-open"].exists)
        app.buttons["cooking-steps-finish"].tap()
        XCTAssertTrue(app.element("suggestion-detail").waitForExistence(timeout: 5))
        XCTAssertTrue(identifier.hasPrefix("suggestion-open-"))
    }
}
