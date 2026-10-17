import XCTest

/// The backend-backed onboarding retains the welcome and a rendered 3D companion.
final class OnboardingCompanionUITests: XCTestCase {
    override func setUp() {
        continueAfterFailure = false
    }

    @MainActor func testTheWelcomeAndDietQuestionShowTheCompanion() {
        let app = XCUIApplication.launched(XCUIApplication.newCook)
        app.buttons["sign-in-fake"].tap()
        XCTAssertTrue(app.buttons["onboarding-start"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.element("onboarding-companion").waitForTomato())
        app.buttons["onboarding-start"].tap()
        XCTAssertTrue(app.element("question-diet").waitForExistence(timeout: 5))
        XCTAssertTrue(app.element("onboarding-companion").waitForTomato())
        app.element("choice-fake-veg").tap()
        app.buttons["onboarding-next"].tap()
        XCTAssertTrue(app.element("question-avoid").waitForExistence(timeout: 5))
    }

    @MainActor func testTheCompanionScreensInLight() {
        captureOnboarding(arguments: ["--appearance-light"], appearance: "light")
    }

    @MainActor func testTheCompanionScreensInDark() {
        captureOnboarding(arguments: ["--appearance-dark"], appearance: "dark")
    }

    @MainActor func testTheWelcomeScrollsAtLargestTextSizeAndBackKeepsAnswers() {
        let app = signedIn(arguments: GalleryLayoutUITests.largestTextSize)
        XCTAssertTrue(app.scrollViews["onboarding-welcome-reading"].exists)
        app.buttons["onboarding-start"].tap()
        app.element("choice-fake-veg").tap()
        app.buttons["onboarding-back"].tap()
        XCTAssertTrue(app.buttons["onboarding-start"].exists)
        app.buttons["onboarding-start"].tap()
        XCTAssertTrue(app.element("choice-fake-veg").isSelected)
        capture(app, name: "diet-largest")
    }

    @MainActor private func signedIn(arguments: [String]) -> XCUIApplication {
        let app = XCUIApplication.launched(XCUIApplication.newCook + arguments)
        app.buttons["sign-in-fake"].tap()
        XCTAssertTrue(app.buttons["onboarding-start"].waitForExistence(timeout: 5))
        return app
    }

    @MainActor private func captureOnboarding(arguments: [String], appearance: String) {
        let app = signedIn(arguments: arguments)
        capture(app, name: "welcome-\(appearance)")
        app.buttons["onboarding-start"].tap()
        XCTAssertTrue(app.element("question-diet").waitForExistence(timeout: 5))
        capture(app, name: "diet-\(appearance)")
        app.buttons["onboarding-next"].tap()
        XCTAssertTrue(app.element("question-avoid").waitForExistence(timeout: 5))
        capture(app, name: "avoid-\(appearance)")
    }

    @MainActor private func capture(_ app: XCUIApplication, name: String) {
        XCTAssertTrue(app.element("onboarding-companion").waitForTomato())
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "onboarding-\(name)"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
