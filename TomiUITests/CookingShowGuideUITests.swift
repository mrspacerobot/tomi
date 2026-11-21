import XCTest

final class CookingShowGuideUITests: XCTestCase {
    override func setUp() { continueAfterFailure = false }

    @MainActor func testGuideAndSettingsInMorningLighting() {
        visit(appearance: "light")
    }

    @MainActor func testGuideAndSettingsInEveningLighting() {
        visit(appearance: "dark")
    }

    @MainActor private func visit(appearance: String) {
        let app = XCUIApplication.launched(
            XCUIApplication.returningCook + ["--appearance-\(appearance)", "--fake-unlisted-avoid"]
        )
        XCTAssertTrue(app.staticTexts["home-title"].waitForExistence(timeout: 5))
        capture("guide-\(appearance)", in: app)
        visitSeasons(in: app, appearance: appearance)
        visitSettings(in: app, appearance: appearance)
    }

    @MainActor private func visitSettings(in app: XCUIApplication, appearance: String) {
        app.buttons["home-settings"].tap()
        XCTAssertTrue(app.element("show-settings-title").waitForExistence(timeout: 5))
        capture("settings-\(appearance)", in: app)
        app.element("settings-question-avoid").tap()
        XCTAssertTrue(app.buttons["settings-save"].waitForExistence(timeout: 5))
        capture("edit-answer-\(appearance)", in: app)
        captureConfirmation(in: app, appearance: appearance)
    }

    @MainActor private func visitSeasons(in app: XCUIApplication, appearance: String) {
        let seasons = app.buttons["guide-seasons-tab"]
        XCTAssertTrue(seasons.waitForExistence(timeout: 5))
        app.assertCanBeTapped(seasons)
        seasons.tap()
        XCTAssertTrue(app.staticTexts["all-seasons-title"].waitForExistence(timeout: 5))
        capture("all-seasons-\(appearance)", in: app)
        visitEpisode(in: app, appearance: appearance)
        app.buttons["seasons-back"].tap()
    }

    @MainActor private func visitEpisode(in app: XCUIApplication, appearance: String) {
        let episode = app.buttons.matching(NSPredicate(format: "identifier BEGINSWITH 'home-skill-'")).firstMatch
        episode.tap()
        XCTAssertTrue(app.staticTexts["episode-title"].waitForExistence(timeout: 5))
        capture("episode-\(appearance)", in: app)
        app.buttons["episode-back"].tap()
    }

    @MainActor private func captureConfirmation(in app: XCUIApplication, appearance: String) {
        let none = app.element("avoid-none")
        app.assertCanBeTapped(none)
        none.tap()
        let save = app.buttons["settings-save"]
        app.assertCanBeTapped(save)
        save.tap()
        XCTAssertTrue(app.buttons["confirm-removal-yes"].firstMatch.waitForExistence(timeout: 5))
        capture("confirm-restriction-\(appearance)", in: app)
    }

    @MainActor private func capture(_ name: String, in app: XCUIApplication) {
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
