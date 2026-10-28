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

    @MainActor
    func testATypedLineIsSpokenAndListed() {
        let app = XCUIApplication()
        app.launchArguments = ["-voice-tryout", "-fake-speaker"]
        app.launch()

        let field = app.textFields["voice-tryout-field"]
        XCTAssertTrue(field.waitForExistence(timeout: 5))
        field.tap()
        field.typeText("Heat the pan.")
        app.buttons["voice-tryout-speak"].tap()

        XCTAssertTrue(app.buttons["Heat the pan."].waitForExistence(timeout: 5))
    }

    @MainActor
    func testATappedSampleLineIsSpokenAndListed() {
        let app = XCUIApplication()
        app.launchArguments = ["-voice-tryout", "-fake-speaker"]
        app.launch()

        let sample = app.buttons["voice-tryout-sample-0"]
        XCTAssertTrue(sample.waitForExistence(timeout: 5))
        let line = sample.label
        sample.tap()

        XCTAssertEqual(app.buttons.matching(NSPredicate(format: "label == %@", line)).count, 2)
    }
}
