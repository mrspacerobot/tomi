import XCTest

final class OpeningEmailCaptureUITests: XCTestCase {
    override func setUp() { continueAfterFailure = false }

    @MainActor func testEmailCasesInTheMorningShow() {
        captureEmail(appearance: "light")
    }

    @MainActor func testEmailCasesInTheEveningShow() {
        captureEmail(appearance: "dark")
    }

    @MainActor private func captureEmail(appearance: String) {
        let launch = XCUIApplication.newCook + ["--appearance-\(appearance)", "--fake-rejects-password"]
        let app = XCUIApplication.launched(launch + ["--capture-opening-lights-up"])
        XCTAssertTrue(app.element("opening-lights-up").waitForExistence(timeout: 5))
        capture("lights-up-\(appearance)", in: app)
        app.terminate()
        app.launchArguments = launch
        app.launch()
        captureWrongPassword(in: app, appearance: appearance)
        captureConfirmation(in: app, appearance: appearance)
    }

    @MainActor private func captureWrongPassword(in app: XCUIApplication, appearance: String) {
        XCTAssertTrue(app.buttons["open-email-auth"].waitForExistence(timeout: 5))
        app.buttons["open-email-auth"].tap()
        fillCredentials(in: app)
        app.buttons["auth-sign-in"].tap()
        XCTAssertTrue(app.staticTexts["auth-sign-in-message"].waitForExistence(timeout: 5))
        XCTAssertEqual(app.textFields["auth-email"].value as? String, "cook@example.com")
        capture("wrong-pass-\(appearance)", in: app)
    }

    @MainActor private func captureConfirmation(in app: XCUIApplication, appearance: String) {
        app.buttons["auth-create-account"].tap()
        app.buttons["auth-create-submit"].tap()
        XCTAssertTrue(app.staticTexts["auth-confirmation-message"].waitForExistence(timeout: 5))
        capture("confirmation-\(appearance)", in: app)
    }

    @MainActor private func fillCredentials(in app: XCUIApplication) {
        let email = app.textFields["auth-email"]
        email.tap()
        email.typeText("cook@example.com")
        let password = app.secureTextFields["auth-password"]
        password.tap()
        password.typeText("correct-horse-battery")
    }

    @MainActor private func capture(_ name: String, in app: XCUIApplication) {
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
