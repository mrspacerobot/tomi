import XCTest

final class CookingShowFridgeUITests: XCTestCase {
    override func setUp() { continueAfterFailure = false }

    @MainActor func testFridgeFlowInMorningLighting() {
        visit(appearance: "light")
        visitEmpty(appearance: "light")
    }

    @MainActor func testFridgeFlowInEveningLighting() {
        visit(appearance: "dark")
        visitEmpty(appearance: "dark")
    }

    @MainActor private func visit(appearance: String) {
        let options = ["--appearance-\(appearance)", "--fake-slow-scan"]
        let app = XCUIApplication.launched(XCUIApplication.returningCook + options)
        app.buttons["home-scan"].tap()
        XCTAssertTrue(app.element("fridge-live-label").waitForExistence(timeout: 5))
        capture("fridge-ready-\(appearance)", in: app)
        readPhoto(in: app, appearance: appearance)
        showMenu(in: app, appearance: appearance)
        visitDetail(in: app, appearance: appearance)
        app.terminate()
    }

    @MainActor private func readPhoto(in app: XCUIApplication, appearance: String) {
        app.buttons["scan-pick-photo"].tap()
        XCTAssertTrue(app.staticTexts["scan-waiting"].waitForExistence(timeout: 5))
        capture("fridge-reading-\(appearance)", in: app)
        XCTAssertTrue(app.element("fridge-photo-preview").waitForExistence(timeout: 15))
        capture("fridge-line-up-\(appearance)", in: app)
    }

    @MainActor private func showMenu(in app: XCUIApplication, appearance: String) {
        let find = app.buttons["confirm-find"]
        app.assertCanBeTapped(find)
        find.tap()
        XCTAssertTrue(app.staticTexts["fridge-menu-title"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.element("suggestion-checked").exists)
        capture("fridge-menu-\(appearance)", in: app)
    }

    @MainActor private func visitDetail(in app: XCUIApplication, appearance: String) {
        let recipe = app.buttons.matching(NSPredicate(format: "identifier BEGINSWITH 'suggestion-open-'")).firstMatch
        app.assertCanBeTapped(recipe)
        recipe.tap()
        XCTAssertTrue(app.element("suggestion-yield").waitForExistence(timeout: 5))
        capture("fridge-recipe-\(appearance)", in: app)
    }

    @MainActor private func visitEmpty(appearance: String) {
        let app = XCUIApplication.launched(XCUIApplication.noSuggestionsCook + ["--appearance-\(appearance)"])
        app.buttons["home-scan"].tap()
        app.buttons["scan-type-instead"].tap()
        XCTAssertTrue(app.element("confirm-title").waitForExistence(timeout: 5))
        app.assertCanBeTapped(app.textFields["confirm-type"])
        app.assertCanBeTapped(app.buttons["confirm-add"])
        capture("fridge-typed-\(appearance)", in: app)
        app.buttons["confirm-find"].tap()
        XCTAssertTrue(app.element("nothing-tonight-title").waitForExistence(timeout: 5))
        capture("fridge-empty-\(appearance)", in: app)
    }

    @MainActor private func capture(_ name: String, in app: XCUIApplication) {
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
