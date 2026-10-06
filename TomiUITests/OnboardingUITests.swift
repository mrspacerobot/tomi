import XCTest

/// The welcome and diet screens of onboarding, driven the way a new cook uses them.
/// The tests keep their data in the UI tests' own store file, never in the cook's store.
final class OnboardingUITests: XCTestCase {
    override func setUp() {
        continueAfterFailure = false
    }

    @MainActor
    func testANewCookSeesTheWelcomeWithOneButton() {
        let app = XCUIApplication.launchedAsNewCook()

        XCTAssertTrue(app.staticTexts["onboarding-welcome-title"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.buttons["onboarding-start"].exists)
        XCTAssertFalse(app.buttons["onboarding-back"].exists)
    }

    @MainActor
    func testTappingADietAdvancesToWhatToAvoid() {
        let app = XCUIApplication.launchedAsNewCook()

        app.buttons["onboarding-start"].tap()
        XCTAssertTrue(app.staticTexts["onboarding-diet-title"].waitForExistence(timeout: 5))
        app.buttons["onboarding-diet-vegetarian"].tap()

        XCTAssertTrue(app.staticTexts["onboarding-avoid-title"].waitForExistence(timeout: 5))
    }

    @MainActor
    func testTheWelcomeShowsTheRenderedCompanion() {
        let app = XCUIApplication.launchedAsNewCook()

        let companion = app.otherElements["onboarding-companion"]
        XCTAssertTrue(companion.waitForExistence(timeout: 5))
        XCTAssertTrue(companion.waitForTomato())
    }

    @MainActor
    func testTheCompanionStaysAndMovesBesideTheDietGreeting() {
        let app = XCUIApplication.launchedAsNewCook()
        let companion = app.otherElements["onboarding-companion"]
        XCTAssertTrue(companion.waitForTomato())
        let welcomeSize = companion.frame.width

        app.buttons["onboarding-start"].tap()

        XCTAssertTrue(app.staticTexts["onboarding-diet-title"].waitForExistence(timeout: 5))
        XCTAssertTrue(companion.waitForTomato())
        XCTAssertLessThan(companion.frame.width, welcomeSize)
        XCTAssertLessThan(companion.frame.maxY, app.staticTexts["onboarding-diet-title"].frame.minY)
    }
}
