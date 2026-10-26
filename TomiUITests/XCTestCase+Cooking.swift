import XCTest

/// The way into the cooking screens that every cooking UI test shares: the fake server, a returning cook, tonight's
/// special, and its introduction.
extension XCTestCase {
    @MainActor func cookingIntroduction(extra: [String] = []) -> (XCUIApplication, String) {
        let app = XCUIApplication.launched(
            XCUIApplication.returningCook + ["--store-in-memory", "--fake-guided-cooking"] + extra
        )
        enterCookingMenu(app)
        return openIntroduction(app)
    }

    @MainActor func enterCookingMenu(_ app: XCUIApplication) {
        app.buttons["home-scan"].tap()
        app.buttons["scan-type-instead"].tap()
        app.buttons["confirm-find"].tap()
    }

    @MainActor func attachScreenshot(of app: XCUIApplication, named name: String) {
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }

    @MainActor private func openIntroduction(_ app: XCUIApplication) -> (XCUIApplication, String) {
        let suggestion = app.buttons.matching(NSPredicate(format: "identifier BEGINSWITH 'suggestion-open-'"))
            .firstMatch
        let identifier = suggestion.identifier
        suggestion.tap()
        app.buttons["cooking-introduction-open"].tap()
        return (app, identifier)
    }
}
