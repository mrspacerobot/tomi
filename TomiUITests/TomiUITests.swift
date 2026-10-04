import XCTest

final class TomiUITests: XCTestCase {
    override func setUp() {
        continueAfterFailure = false
    }

    @MainActor
    func testLaunchShowsTomi() {
        let app = XCUIApplication()
        app.launchArguments = ["--store-in-memory"]
        app.launch()

        XCTAssertTrue(app.staticTexts["welcome-title"].waitForExistence(timeout: 5))
        XCTAssertEqual(app.staticTexts["welcome-subtitle"].label, "12 techniques in 4 courses")
    }
}
