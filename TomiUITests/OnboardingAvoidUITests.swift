import XCTest

/// "Anything to avoid?" and what onboarding keeps, driven the way a new cook uses them.
/// The tests keep their data in the UI tests' own store file, never in the cook's store.
final class OnboardingAvoidUITests: XCTestCase {
    override func setUp() {
        continueAfterFailure = false
    }

    @MainActor
    func testContinueWaitsForATickOrNoneOfThese() {
        let app = XCUIApplication.launchedAsNewCook()
        app.reachWhatToAvoid()

        XCTAssertFalse(app.buttons["onboarding-continue"].isEnabled)
        app.buttons["onboarding-avoid-nuts"].tap()
        XCTAssertTrue(app.buttons["onboarding-continue"].isEnabled)
        app.buttons["onboarding-avoid-nuts"].tap()
        XCTAssertFalse(app.buttons["onboarding-continue"].isEnabled)
        app.buttons["onboarding-avoid-none"].tap()
        XCTAssertTrue(app.buttons["onboarding-continue"].isEnabled)
    }

    @MainActor
    func testNoneOfTheseClearsTheTicks() {
        let app = XCUIApplication.launchedAsNewCook()
        app.reachWhatToAvoid()

        app.buttons["onboarding-avoid-nuts"].tap()
        app.buttons["onboarding-avoid-dairy"].tap()
        app.buttons["onboarding-avoid-none"].tap()

        XCTAssertTrue(app.buttons["onboarding-avoid-none"].isSelected)
        XCTAssertFalse(app.buttons["onboarding-avoid-nuts"].isSelected)
        XCTAssertFalse(app.buttons["onboarding-avoid-dairy"].isSelected)
    }

    @MainActor
    func testATickClearsNoneOfThese() {
        let app = XCUIApplication.launchedAsNewCook()
        app.reachWhatToAvoid()

        app.buttons["onboarding-avoid-none"].tap()
        app.buttons["onboarding-avoid-nuts"].tap()

        XCTAssertFalse(app.buttons["onboarding-avoid-none"].isSelected)
        XCTAssertTrue(app.buttons["onboarding-avoid-nuts"].isSelected)
    }

    @MainActor
    func testThePackagingNoteIsShown() {
        let app = XCUIApplication.launchedAsNewCook()
        app.reachWhatToAvoid()

        XCTAssertTrue(app.staticTexts["onboarding-avoid-note"].exists)
    }

    @MainActor
    func testBackKeepsTheEarlierAnswers() {
        let app = XCUIApplication.launchedAsNewCook()
        app.reachWhatToAvoid()
        app.buttons["onboarding-avoid-nuts"].tap()

        app.buttons["onboarding-back"].tap()
        XCTAssertTrue(app.buttons["onboarding-diet-vegetarian"].isSelected)
        app.buttons["onboarding-back"].tap()
        XCTAssertTrue(app.buttons["onboarding-start"].waitForExistence(timeout: 5))
        app.buttons["onboarding-start"].tap()
        app.buttons["onboarding-diet-vegetarian"].tap()

        XCTAssertTrue(app.buttons["onboarding-avoid-nuts"].isSelected)
    }

    @MainActor
    func testTheAnswersAreStillThereAfterARelaunch() {
        let app = XCUIApplication.launchedAsNewCook()
        app.reachWhatToAvoid()
        app.buttons["onboarding-avoid-nuts"].tap()
        app.buttons["onboarding-continue"].tap()
        app.terminate()

        let relaunched = XCUIApplication.launched(["--store-ui-test-file"])
        relaunched.buttons["onboarding-start"].tap()
        XCTAssertTrue(relaunched.buttons["onboarding-diet-vegetarian"].isSelected)
        relaunched.buttons["onboarding-diet-vegetarian"].tap()
        XCTAssertTrue(relaunched.buttons["onboarding-avoid-nuts"].isSelected)
    }
}
