import XCTest

/// The parts a cook only reads (stats, box, progress rule), and every part at the largest text size.
final class GalleryLayoutUITests: XCTestCase {
    static let largestTextSize = ["-UIPreferredContentSizeCategoryName", "UICTContentSizeCategoryAccessibilityXXXL"]
    static let tappable = [
        "gallery-button-primary", "gallery-button-secondary", "gallery-single-0", "gallery-multiple-0",
        "gallery-chip-staple", "gallery-chip-tonight", "gallery-chip-removable", "gallery-chip-unsure",
        "gallery-progress-next",
    ]

    override func setUp() {
        continueAfterFailure = false
    }

    @MainActor
    func testTheProgressRuleSaysHowFarTheCookIs() {
        let app = XCUIApplication.launchingGallery()
        let rule = app.element("gallery-progress")
        XCTAssertEqual(rule.label, "Progress")
        XCTAssertEqual(rule.value as? String, "2 of 6")

        app.buttons["gallery-progress-next"].tap()
        XCTAssertEqual(rule.value as? String, "3 of 6")
    }

    @MainActor
    func testEachStatIsReadAsOneLine() {
        let app = XCUIApplication.launchingGallery()

        XCTAssertTrue(app.element(labelled: "Streak, 3 weeks, 1 of 3 this week").exists)
        XCTAssertTrue(app.element(labelled: "To level 3, 67 XP, 183 of 250").exists)
    }

    @MainActor
    func testTheBoxShowsItsFlagAndWhatIsInside() {
        let app = XCUIApplication.launchingGallery()

        XCTAssertTrue(app.element(labelled: "Tonight's special").exists)
        XCTAssertTrue(app.staticTexts["gallery-box-title"].exists)
    }

    @MainActor
    func testSamplesInBothAppearances() {
        for appearance in ["light", "dark"] {
            let app = XCUIApplication.launchingGallery(extraArguments: ["--appearance-\(appearance)"])
            attachScreenshot(of: app, named: "samples-\(appearance)")
            captureCompanion(in: app, appearance: appearance)
            app.assertCanBeTapped(app.buttons["gallery-single-0"])
            attachScreenshot(of: app, named: "sample-choices-\(appearance)")
            app.terminate()
        }
    }

    @MainActor private func captureCompanion(in app: XCUIApplication, appearance: String) {
        app.buttons["gallery-companion"].tap()
        XCTAssertTrue(app.staticTexts["companion-title"].waitForExistence(timeout: 5))
        attachScreenshot(of: app, named: "companion-sample-\(appearance)")
        app.buttons["companion-close"].tap()
        XCTAssertTrue(app.staticTexts["gallery-title"].waitForExistence(timeout: 5))
    }

    @MainActor
    func testEveryComponentCanBeTappedInDefaultText() {
        let app = XCUIApplication.launchingGallery()

        for identifier in Self.tappable {
            app.assertCanBeTapped(app.buttons[identifier])
        }
    }

    @MainActor
    func testEveryComponentCanBeTappedAtTheLargestTextSize() {
        let app = XCUIApplication.launchingGallery(extraArguments: Self.largestTextSize)

        for identifier in Self.tappable {
            app.assertCanBeTapped(app.buttons[identifier])
        }
    }
}
