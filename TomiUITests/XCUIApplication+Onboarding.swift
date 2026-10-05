import XCTest

extension XCUIApplication {
    /// Launches as a new cook: the UI tests' own store, emptied first.
    @MainActor
    static func launchedAsNewCook() -> XCUIApplication {
        launched(["--store-ui-test-file", "--store-start-empty"])
    }

    @MainActor
    static func launched(_ arguments: [String]) -> XCUIApplication {
        let app = XCUIApplication()
        app.launchArguments = arguments
        app.launch()
        return app
    }

    /// Taps through the welcome and the diet question, choosing vegetarian.
    @MainActor
    func reachWhatToAvoid() {
        buttons["onboarding-start"].tap()
        buttons["onboarding-diet-vegetarian"].tap()
        XCTAssertTrue(staticTexts["onboarding-avoid-title"].waitForExistence(timeout: 5))
    }
}
