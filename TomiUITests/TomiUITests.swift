import XCTest

final class TomiUITests: XCTestCase {
    override func setUp() {
        continueAfterFailure = false
    }

    @MainActor
    func testLaunchShowsTomi() {
        let app = XCUIApplication.launched(XCUIApplication.returningCook + ["--store-in-memory"])

        XCTAssertTrue(app.staticTexts["home-title"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts["home-date"].exists)
        XCTAssertTrue(app.buttons["home-settings"].exists)
        XCTAssertTrue(app.otherElements["home-progress-strip"].exists)
        XCTAssertTrue(app.otherElements["home-menu"].exists)
    }
}
