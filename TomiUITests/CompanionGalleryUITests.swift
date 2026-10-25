import XCTest

final class CompanionGalleryUITests: XCTestCase {
    static let states = ["idle", "listening", "thinking", "explaining", "celebrating"]

    override func setUp() {
        continueAfterFailure = false
    }

    @MainActor func testTheGalleryOpensTheAnimatedCompanion() async {
        let app = XCUIApplication.launchingGallery()
        app.buttons["gallery-companion"].tap()
        XCTAssertTrue(app.staticTexts["companion-title"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.buttons["companion-state-idle"].isSelected)
        await app.element("companion-stage").assertTomatoRendered()
    }

    @MainActor func testEveryStateAndTheStillControlWork() {
        let app = companion()
        for state in Self.states {
            app.assertCanBeTapped(app.buttons["companion-state-\(state)"])
            app.buttons["companion-state-\(state)"].tap()
            XCTAssertTrue(app.buttons["companion-state-\(state)"].isSelected)
        }
        app.assertCanBeTapped(app.buttons["companion-still"])
        app.buttons["companion-still"].tap()
        XCTAssertTrue(app.buttons["companion-still"].isSelected)
        XCTAssertTrue(app.staticTexts["companion-motion-still"].exists)
    }

    /// Each mood must be recognisable without motion, so no two still poses may draw the same picture.
    @MainActor func testEveryStateDrawsADifferentStillPose() {
        let app = companion(arguments: ["--companion-reduce-motion"])
        var drawings: [String: Data] = [:]
        for state in Self.states {
            app.buttons["companion-state-\(state)"].tap()
            drawings[state] = app.element("companion-viewport").screenshot().pngRepresentation
        }
        XCTAssertEqual(Set(drawings.values).count, drawings.count)
    }

    @MainActor func testControlsWorkWithLargestTextAndReducedMotion() {
        let app = companion(arguments: GalleryLayoutUITests.largestTextSize + ["--companion-reduce-motion"])
        app.assertCanBeTapped(app.buttons["companion-state-celebrating"])
        app.buttons["companion-state-celebrating"].tap()
        XCTAssertTrue(app.buttons["companion-state-celebrating"].isSelected)
        XCTAssertGreaterThan(app.buttons["companion-state-celebrating"].frame.width, app.frame.width * 0.7)
        XCTAssertTrue(app.staticTexts["companion-motion-still"].exists)
        app.assertCanBeTapped(app.buttons["companion-still"])
        captureLargestControls(in: app)
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

    @MainActor private func captureLargestControls(in app: XCUIApplication) {
        let original = XCUIDevice.shared.appearance
        addTeardownBlock { @MainActor in XCUIDevice.shared.appearance = original }
        XCUIDevice.shared.appearance = .dark
        waitForAppearance(.dark, in: app)
        capture(app, named: "Companion largest controls - dark")
        XCUIDevice.shared.appearance = .light
        waitForAppearance(.light, in: app)
        capture(app, named: "Companion largest controls - light")
    }

    @MainActor private func capture(_ app: XCUIApplication, named name: String) {
        let capture = XCTAttachment(screenshot: app.screenshot())
        capture.name = name
        capture.lifetime = .keepAlways
        add(capture)
    }
}
