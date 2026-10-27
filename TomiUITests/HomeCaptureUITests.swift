import XCTest

/// Captures the Home progress states for the pull request: a returning cook with the server's progress, the same
/// cook offline with unsent cooks, and a new cook offline before any progress arrived.
final class HomeCaptureUITests: XCTestCase {
    override func setUp() { continueAfterFailure = false }

    @MainActor func testReturningCookLight() { capture("returning-cook-light", Self.returning) }
    @MainActor func testReturningCookDark() { capture("returning-cook-dark", Self.returning + Self.dark) }
    @MainActor func testReturningCookAtLargestTextDark() {
        capture("returning-cook-largest-text-dark", Self.returning + Self.dark + GalleryLayoutUITests.largestTextSize)
    }

    @MainActor func testOfflineCookLight() { capture("offline-unsent-light", Self.offline, note: true) }
    @MainActor func testOfflineCookDark() { capture("offline-unsent-dark", Self.offline + Self.dark, note: true) }
    @MainActor func testOfflineCookAtLargestTextLight() {
        capture("offline-unsent-largest-text-light", Self.offline + GalleryLayoutUITests.largestTextSize, note: true)
    }

    @MainActor func testNewCookOfflineLight() { capture("new-cook-offline-light", Self.newOffline, note: true) }
    @MainActor func testNewCookOfflineDark() {
        capture("new-cook-offline-dark", Self.newOffline + Self.dark, note: true)
    }

    private static let returning = ["--store-in-memory", "--seed-known-state"]
    private static let offline = returning + ["--fake-cook-entries-offline"]
    private static let newOffline = ["--store-in-memory", "--fake-cook-entries-offline"]
    private static let dark = ["--appearance-dark"]

    @MainActor private func capture(_ name: String, _ arguments: [String], note: Bool = false) {
        let app = XCUIApplication.launched(XCUIApplication.returningCook + arguments)
        XCTAssertTrue(app.staticTexts["home-title"].waitForExistence(timeout: 5))
        if note {
            XCTAssertTrue(app.staticTexts["home-progress-note"].waitForExistence(timeout: 5))
        } else {
            XCTAssertTrue(app.otherElements["home-progress-strip"].waitForExistence(timeout: 5))
        }
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
