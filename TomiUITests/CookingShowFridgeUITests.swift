import XCTest

final class CookingShowFridgeUITests: XCTestCase {
    override func setUp() { continueAfterFailure = false }

    @MainActor func testFridgeFlowInMorningLighting() {
        visit(appearance: "light")
    }

    @MainActor func testFridgeFlowInEveningLighting() {
        visit(appearance: "dark")
    }

    @MainActor private func visit(appearance: String) {
        let app = XCUIApplication.launched(XCUIApplication.returningCook + ["--appearance-\(appearance)"])
        app.buttons["home-scan"].tap()
        XCTAssertTrue(app.element("fridge-live-label").waitForExistence(timeout: 5))
        capture("fridge-ready-\(appearance)", in: app)
        app.buttons["scan-pick-photo"].tap()
        XCTAssertTrue(app.element("fridge-photo-preview").waitForExistence(timeout: 5))
        capture("fridge-line-up-\(appearance)", in: app)
        showMenu(in: app, appearance: appearance)
    }

    @MainActor private func showMenu(in app: XCUIApplication, appearance: String) {
        let find = app.buttons["confirm-find"]
        app.assertCanBeTapped(find)
        find.tap()
        XCTAssertTrue(app.staticTexts["fridge-menu-title"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.element("suggestion-checked").exists)
        capture("fridge-menu-\(appearance)", in: app)
    }

    @MainActor private func capture(_ name: String, in app: XCUIApplication) {
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
