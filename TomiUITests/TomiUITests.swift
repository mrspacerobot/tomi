import XCTest

final class TomiUITests: XCTestCase {
    override func setUp() {
        continueAfterFailure = false
    }

    @MainActor
    func testLaunchShowsTomi() {
        let app = XCUIApplication.launched(XCUIApplication.returningCook + ["--store-in-memory"])

        XCTAssertTrue(app.staticTexts["welcome-title"].waitForExistence(timeout: 5))
        XCTAssertEqual(app.staticTexts["welcome-subtitle"].label, "12 techniques in 4 courses")
    }
}
