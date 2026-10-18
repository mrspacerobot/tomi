import XCTest

/// The native Apple sign-in control stays a button-sized target in the real sign-in flow.
final class SignInButtonUITests: XCTestCase {
    override func setUp() {
        continueAfterFailure = false
    }

    @MainActor func testAppleSignInButtonStaysAtTouchTargetHeight() {
        let app = XCUIApplication.launched([
            "--fake-backend",
            "--store-in-memory",
            "--apple-sign-in-button",
        ])
        let button = app.element("sign-in-apple")
        XCTAssertTrue(button.waitForExistence(timeout: 5))
        XCTAssertLessThan(button.frame.height, app.frame.height / 5)
    }
}
