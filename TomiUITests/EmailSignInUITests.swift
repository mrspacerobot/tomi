import XCTest

final class EmailSignInUITests: XCTestCase {
    override func setUp() {
        continueAfterFailure = false
    }

    @MainActor
    func testCookCanSignInWithEmailAndPassword() {
        let app = XCUIApplication.launched(XCUIApplication.newCook)

        XCTAssertTrue(app.textFields["auth-email"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.secureTextFields["auth-password"].exists)
        XCTAssertTrue(app.buttons["auth-sign-in"].exists)
        app.textFields["auth-email"].tap()
        app.textFields["auth-email"].typeText("cook@example.com")
        enterPassword("correct-horse-battery", in: app)
        app.buttons["auth-sign-in"].tap()

        XCTAssertTrue(app.buttons["onboarding-start"].waitForExistence(timeout: 5))
    }

    @MainActor
    func testCookCanCreateAnAccount() {
        let app = XCUIApplication.launched(XCUIApplication.newCook)

        XCTAssertTrue(app.buttons["auth-create-account"].waitForExistence(timeout: 5))
        app.buttons["auth-create-account"].tap()
        XCTAssertTrue(app.buttons["auth-create-submit"].exists)
        enterEmail("cook@example.com", in: app)
        enterPassword("correct-horse-battery", in: app)
        app.buttons["auth-create-submit"].tap()
        XCTAssertTrue(app.staticTexts["auth-confirmation-message"].waitForExistence(timeout: 5))
    }

    @MainActor
    func testCookCanRequestPasswordReset() {
        let app = XCUIApplication.launched(XCUIApplication.newCook)

        XCTAssertTrue(app.buttons["auth-forgot-password"].waitForExistence(timeout: 5))
        app.buttons["auth-forgot-password"].tap()
        XCTAssertTrue(app.buttons["auth-reset-submit"].exists)
        XCTAssertFalse(app.secureTextFields["auth-password"].exists)
        enterEmail("cook@example.com", in: app)
        app.buttons["auth-reset-submit"].tap()
        XCTAssertTrue(app.staticTexts["auth-recovery-message"].waitForExistence(timeout: 5))
    }

    @MainActor
    func testMalformedEmailIsRefusedBeforeSigningIn() {
        let app = XCUIApplication.launched(XCUIApplication.newCook)

        XCTAssertTrue(app.buttons["auth-sign-in"].waitForExistence(timeout: 5))
        enterEmail("not-an-email", in: app)
        enterPassword("correct-horse-battery", in: app)
        app.buttons["auth-sign-in"].tap()

        XCTAssertTrue(app.staticTexts["auth-sign-in-message"].waitForExistence(timeout: 5))
        XCTAssertFalse(app.buttons["onboarding-start"].exists)
    }

    @MainActor
    func testShortPasswordIsRefusedWhenCreatingAnAccount() {
        let app = XCUIApplication.launched(XCUIApplication.newCook)

        XCTAssertTrue(app.buttons["auth-create-account"].waitForExistence(timeout: 5))
        app.buttons["auth-create-account"].tap()
        enterEmail("cook@example.com", in: app)
        enterPassword("12345", in: app)
        app.buttons["auth-create-submit"].tap()

        XCTAssertTrue(app.staticTexts["auth-confirmation-message"].waitForExistence(timeout: 5))
    }

    @MainActor
    private func enterEmail(_ email: String, in app: XCUIApplication) {
        let field = app.textFields["auth-email"]
        field.tap()
        field.typeText(email)
    }

    @MainActor
    private func enterPassword(_ password: String, in app: XCUIApplication) {
        let field = app.secureTextFields["auth-password"]
        field.tap()
        field.typeText(password)
    }
}
