import XCTest

final class CompanionGalleryUITests: XCTestCase {
    override func setUp() {
        continueAfterFailure = false
    }

    @MainActor func testTheGalleryOpensTheAnimatedCompanion() {
        let app = XCUIApplication.launchingGallery()
        app.buttons["gallery-companion"].tap()
        XCTAssertTrue(app.staticTexts["companion-title"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.buttons["companion-state-idle"].isSelected)
        XCTAssertGreaterThan(app.element("companion-stage").screenshot().tomatoCoverage, 0.015)
    }

    @MainActor func testEveryStateAndDepthControlWorks() {
        let app = companion()
        for state in ["idle", "listening", "thinking", "explaining", "celebrating"] {
            app.assertCanBeTapped(app.buttons["companion-state-\(state)"])
            app.buttons["companion-state-\(state)"].tap()
            XCTAssertTrue(app.buttons["companion-state-\(state)"].isSelected)
        }
        app.assertCanBeTapped(app.buttons["companion-turn"])
        app.buttons["companion-turn"].tap()
        XCTAssertTrue(app.buttons["companion-turn"].isSelected)
    }

    @MainActor func testControlsWorkWithLargestTextAndReducedMotion() {
        let app = companion(arguments: GalleryLayoutUITests.largestTextSize + ["--companion-reduce-motion"])
        app.assertCanBeTapped(app.buttons["companion-state-celebrating"])
        app.buttons["companion-state-celebrating"].tap()
        XCTAssertTrue(app.buttons["companion-state-celebrating"].isSelected)
        app.assertCanBeTapped(app.buttons["companion-turn"])
        app.buttons["companion-turn"].tap()
        XCTAssertTrue(app.staticTexts["companion-motion-still"].exists)
    }

    @MainActor func testDirectGalleryClosesAndReopens() {
        let app = XCUIApplication()
        app.launchArguments = ["--companion-gallery", "--store-in-memory"]
        app.launch()
        XCTAssertTrue(app.staticTexts["companion-title"].waitForExistence(timeout: 5))
        app.buttons["companion-close"].tap()
        XCTAssertTrue(app.staticTexts["gallery-title"].waitForExistence(timeout: 5))
        app.buttons["gallery-companion"].tap()
        XCTAssertTrue(app.staticTexts["companion-title"].waitForExistence(timeout: 5))
    }

    @MainActor private func companion(arguments: [String] = []) -> XCUIApplication {
        let app = XCUIApplication.launchingGallery(extraArguments: arguments)
        app.buttons["gallery-companion"].tap()
        XCTAssertTrue(app.staticTexts["companion-title"].waitForExistence(timeout: 5))
        return app
    }
}
