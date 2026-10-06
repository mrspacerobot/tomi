import XCTest

/// The welcome of onboarding at the largest text size a cook can choose.
final class OnboardingLargeTextUITests: XCTestCase {
    override func setUp() {
        continueAfterFailure = false
    }

    /// Only the button stays put. Everything else scrolls, so the promise is not squeezed into a strip.
    @MainActor
    func testTheWelcomeKeepsMostOfTheScreenForReading() {
        let arguments = ["--store-ui-test-file", "--store-start-empty"] + GalleryLayoutUITests.largestTextSize
        let app = XCUIApplication.launched(arguments)
        XCTAssertTrue(app.staticTexts["onboarding-welcome-title"].waitForExistence(timeout: 5))

        let reading = app.scrollViews["onboarding-welcome-reading"]
        XCTAssertTrue(reading.exists)
        XCTAssertGreaterThan(reading.frame.height, app.frame.height * 0.6)
        XCTAssertLessThanOrEqual(reading.frame.maxY, app.buttons["onboarding-start"].frame.minY)
    }
}
