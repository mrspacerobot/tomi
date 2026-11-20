import XCTest

/// Captures tonight's menu with the fake dish photo for the pull request, in light, dark and at the largest text.
final class SuggestionPhotoCaptureUITests: XCTestCase {
    override func setUp() { continueAfterFailure = false }

    @MainActor func testMenuWithPhotoLight() { capture("menu-photo-light", []) }
    @MainActor func testMenuWithPhotoDark() { capture("menu-photo-dark", ["--appearance-dark"]) }
    @MainActor func testMenuWithPhotoAtLargestTextLight() {
        capture("menu-photo-largest-text-light", GalleryLayoutUITests.largestTextSize)
    }

    @MainActor private func capture(_ name: String, _ arguments: [String]) {
        let launch = XCUIApplication.returningCook + ["--store-in-memory", "--fake-dish-photos"] + arguments
        let app = XCUIApplication.launched(launch)
        XCTAssertTrue(app.buttons["home-scan"].waitForExistence(timeout: 5))
        app.buttons["home-scan"].tap()
        XCTAssertTrue(app.buttons["scan-type-instead"].waitForExistence(timeout: 5))
        app.buttons["scan-type-instead"].tap()
        XCTAssertTrue(app.buttons["confirm-find"].waitForExistence(timeout: 5))
        app.buttons["confirm-find"].tap()
        waitForThePhoto(in: app)
        attach(app, named: name)
    }

    /// The photo is hidden from VoiceOver, so no query can see it arrive. The fake serves it from the bundle at
    /// once; two seconds leave time to decode it. These captures are checked by eye, they assert nothing about it.
    @MainActor private func waitForThePhoto(in app: XCUIApplication) {
        let title = app.staticTexts.matching(NSPredicate(format: "identifier BEGINSWITH 'suggestion-title-'"))
            .firstMatch
        XCTAssertTrue(title.waitForExistence(timeout: 5))
        _ = XCTWaiter().wait(for: [XCTestExpectation(description: "The photo decodes")], timeout: 2)
    }

    @MainActor private func attach(_ app: XCUIApplication, named name: String) {
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
