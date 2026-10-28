import XCTest

/// Captures the cooking step and its save failure with fake data.
final class CookingSaveCaptureUITests: XCTestCase {
    override func setUp() { continueAfterFailure = false }

    @MainActor func testLight() { capture(appearance: "--appearance-light", name: "light") }
    @MainActor func testDark() { capture(appearance: "--appearance-dark", name: "dark") }
    @MainActor func testLargestTextDark() {
        capture(appearance: "--appearance-dark", name: "largest-dark", extra: GalleryLayoutUITests.largestTextSize)
    }

    @MainActor private func capture(appearance: String, name: String, extra: [String] = []) {
        let args =
            [appearance, "--seed-known-state", "--store-fail-first-cook-save", "--fake-cook-entries-offline"] + extra
        let app = cookingIntroduction(store: "--store-in-memory", extra: args).0
        beginAndWalkAllSteps(app)
        attachScreenshot(of: app, named: "cooking-step-\(name)")
        app.buttons["cooking-steps-finish"].tap()
        XCTAssertTrue(app.alerts.staticTexts["Tomi could not save your cook"].waitForExistence(timeout: 5))
        attachScreenshot(of: app, named: "cooking-save-failure-\(name)")
    }
}
