import XCTest

/// The primary and the secondary button: a tap acts, and a disabled button says so and does nothing.
final class GalleryButtonUITests: XCTestCase {
    override func setUp() {
        continueAfterFailure = false
    }

    @MainActor
    func testTappingThePrimaryAndTheSecondaryButtonActs() {
        let app = XCUIApplication.launchingGallery()
        XCTAssertEqual(app.staticTexts["gallery-button-taps"].label, "Tapped 0 times")

        app.buttons["gallery-button-primary"].tap()
        XCTAssertEqual(app.staticTexts["gallery-button-taps"].label, "Tapped 1 time")

        app.buttons["gallery-button-secondary"].tap()
        XCTAssertEqual(app.staticTexts["gallery-button-taps"].label, "Tapped 2 times")
    }

    @MainActor
    func testADisabledButtonIsExposedAsDisabledAndDoesNothing() {
        let app = XCUIApplication.launchingGallery()
        let disabled = app.buttons["gallery-button-disabled"]

        XCTAssertTrue(app.buttons["gallery-button-primary"].isEnabled)
        XCTAssertFalse(disabled.isEnabled)

        disabled.tap()
        XCTAssertEqual(app.staticTexts["gallery-button-taps"].label, "Tapped 0 times")
    }

    @MainActor
    func testButtonsAreNamedAndLargeEnoughToTap() {
        let app = XCUIApplication.launchingGallery()

        XCTAssertEqual(app.buttons["gallery-button-primary"].label, "Start cooking")
        XCTAssertEqual(app.buttons["gallery-button-secondary"].label, "Scan again")
        app.assertCanBeTapped(app.buttons["gallery-button-primary"])
        app.assertCanBeTapped(app.buttons["gallery-button-secondary"])
    }
}
