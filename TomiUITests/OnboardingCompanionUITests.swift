import XCTest

/// The backend-backed onboarding retains the welcome and a rendered 3D companion.
final class OnboardingCompanionUITests: XCTestCase {
    override func setUp() {
        continueAfterFailure = false
    }

    @MainActor func testTheWelcomeAndDietQuestionShowTheCompanion() async {
        let app = XCUIApplication.launched(XCUIApplication.newCook)
        app.buttons["sign-in-fake"].tap()
        XCTAssertTrue(app.buttons["onboarding-start"].waitForExistence(timeout: 5))
        await app.element("onboarding-companion").assertTomatoRendered()
        app.buttons["onboarding-start"].tap()
        XCTAssertTrue(app.element("question-diet").waitForExistence(timeout: 5))
        await app.element("onboarding-companion").assertTomatoRendered()
        app.element("choice-fake-veg").tap()
        app.buttons["onboarding-next"].tap()
        XCTAssertTrue(app.element("question-avoid").waitForExistence(timeout: 5))
    }

    @MainActor func testTheCompanionScreensInLight() async {
        await captureOnboarding(arguments: ["--appearance-light"], appearance: "light")
    }

    @MainActor func testTheCompanionScreensInDark() async {
        await captureOnboarding(arguments: ["--appearance-dark"], appearance: "dark")
    }

    @MainActor func testTheWelcomeScrollsAtLargestTextSizeAndBackKeepsAnswers() async {
        let app = signedIn(arguments: GalleryLayoutUITests.largestTextSize + ["--appearance-dark"])
        XCTAssertTrue(app.scrollViews["onboarding-welcome-reading"].exists)
        await capture(app, name: "welcome-largest-dark")
        app.buttons["onboarding-start"].tap()
        app.element("choice-fake-veg").tap()
        app.buttons["onboarding-back"].tap()
        XCTAssertTrue(app.buttons["onboarding-start"].exists)
        app.buttons["onboarding-start"].tap()
        XCTAssertTrue(app.element("choice-fake-veg").isSelected)
        await capture(app, name: "diet-largest-dark")
    }

    @MainActor func testTheGreetingUsesTheScreenWidthAtLargestTextSize() async {
        let app = signedIn(arguments: GalleryLayoutUITests.largestTextSize + ["--appearance-light"])
        await capture(app, name: "welcome-largest-light")
        app.buttons["onboarding-start"].tap()
        XCTAssertGreaterThan(app.element("onboarding-greeting").frame.width, app.frame.width * 0.8)
        await capture(app, name: "diet-largest-light")
    }

    @MainActor private func signedIn(arguments: [String]) -> XCUIApplication {
        let app = XCUIApplication.launched(XCUIApplication.newCook + arguments)
        app.buttons["sign-in-fake"].tap()
        XCTAssertTrue(app.buttons["onboarding-start"].waitForExistence(timeout: 5))
        return app
    }

    @MainActor private func captureOnboarding(arguments: [String], appearance: String) async {
        let app = signedIn(arguments: arguments)
        await capture(app, name: "welcome-\(appearance)")
        app.buttons["onboarding-start"].tap()
        XCTAssertTrue(app.element("question-diet").waitForExistence(timeout: 5))
        await capture(app, name: "diet-\(appearance)")
        app.buttons["onboarding-next"].tap()
        XCTAssertTrue(app.element("question-avoid").waitForExistence(timeout: 5))
        await capture(app, name: "avoid-\(appearance)")
    }

    @MainActor private func capture(_ app: XCUIApplication, name: String) async {
        await app.element("onboarding-companion").assertTomatoRendered()
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "onboarding-\(name)"
        attachment.lifetime = .keepAlways
        add(attachment)
    }

}
