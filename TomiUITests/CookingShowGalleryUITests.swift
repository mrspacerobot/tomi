import XCTest

final class CookingShowGalleryUITests: XCTestCase {
    override func setUp() {
        continueAfterFailure = false
    }

    @MainActor func testComponentsInTheMorningShow() {
        showGallery(appearance: "light", extraArguments: [])
    }

    @MainActor func testComponentsInTheEveningShow() {
        showGallery(appearance: "dark", extraArguments: [])
    }

    @MainActor func testLargestTextInTheMorningShow() {
        showGallery(appearance: "light", extraArguments: GalleryLayoutUITests.largestTextSize)
    }

    @MainActor func testLargestTextInTheEveningShow() {
        showGallery(appearance: "dark", extraArguments: GalleryLayoutUITests.largestTextSize)
    }

    @MainActor private func showGallery(appearance: String, extraArguments: [String]) {
        let launch = ["--cooking-show-gallery", "--fake-backend", "--store-in-memory", "--appearance-\(appearance)"]
        let app = XCUIApplication.launched(launch + extraArguments)
        let name = captureName(appearance, largest: !extraArguments.isEmpty)
        checkDisplays(in: app)
        capture("\(name)-stage", in: app)
        checkControls(in: app)
        checkTabs(in: app)
        capture("\(name)-controls", in: app)
    }

    @MainActor private func checkDisplays(in app: XCUIApplication) {
        XCTAssertTrue(app.element(labelled: "Cooking Show").waitForExistence(timeout: 5))
        XCTAssertTrue(app.element("show-gallery-lower-third").exists)
        XCTAssertTrue(app.element("show-gallery-bubble").exists)
        XCTAssertTrue(app.element("show-gallery-card").exists)
    }

    @MainActor private func checkControls(in app: XCUIApplication) {
        let back = app.buttons["show-gallery-back"]
        let chip = app.buttons["show-gallery-chip"]
        let primary = app.buttons["show-gallery-primary"]
        app.assertCanBeTapped(back)
        app.assertCanBeTapped(chip)
        app.assertCanBeTapped(primary)
        primary.tap()
        XCTAssertTrue(chip.isSelected)
        chip.tap()
        XCTAssertFalse(chip.isSelected)
    }

    @MainActor private func checkTabs(in app: XCUIApplication) {
        let table = app.buttons["Table"]
        let guide = app.buttons["Episode guide"]
        XCTAssertTrue(guide.isSelected)
        app.assertCanBeTapped(table)
        table.tap()
        XCTAssertTrue(table.isSelected)
        XCTAssertFalse(guide.isSelected)
    }

    private func captureName(_ appearance: String, largest: Bool) -> String {
        if largest { return "\(appearance)-largest" }
        return appearance
    }

    @MainActor private func capture(_ name: String, in app: XCUIApplication) {
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
