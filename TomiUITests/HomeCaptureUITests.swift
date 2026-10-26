import XCTest

/// Captures the Home states for the pull request: a new cook, and a cook with saved progress.
final class HomeCaptureUITests: XCTestCase {
    override func setUp() { continueAfterFailure = false }

    @MainActor func testNewCookLight() { captureHome(of: "new-cook-light", arguments: ["--store-in-memory"]) }

    @MainActor func testNewCookDark() {
        captureHome(of: "new-cook-dark", arguments: ["--store-in-memory", "--appearance-dark"])
    }

    @MainActor func testReturningCookLight() { captureHome(of: "returning-cook-light", arguments: Self.seeded) }

    @MainActor func testReturningCookDark() {
        captureHome(of: "returning-cook-dark", arguments: Self.seeded + ["--appearance-dark"])
    }

    @MainActor func testReturningCookAtLargestTextDark() {
        let arguments = Self.seeded + ["--appearance-dark"] + GalleryLayoutUITests.largestTextSize
        captureHome(of: "returning-cook-largest-text-dark", arguments: arguments)
    }

    private static let seeded = ["--store-ui-test-file", "--seed-known-state"]

    @MainActor private func captureHome(of name: String, arguments: [String]) {
        let app = XCUIApplication.launched(XCUIApplication.returningCook + arguments)
        XCTAssertTrue(app.otherElements["home-progress-strip"].waitForExistence(timeout: 5))
        attach(app, named: name)
        app.swipeUp()
        attach(app, named: name + "-menu")
    }

    @MainActor private func attach(_ app: XCUIApplication, named name: String) {
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
