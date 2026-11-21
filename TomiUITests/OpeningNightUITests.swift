import XCTest

final class OpeningNightUITests: XCTestCase {
    override func setUp() { continueAfterFailure = false }

    @MainActor func testOpeningNightInMorningLighting() {
        visit(appearance: "light")
    }

    @MainActor func testOpeningNightInEveningLighting() {
        visit(appearance: "dark")
    }

    @MainActor private func visit(appearance: String) {
        let app = XCUIApplication.launched(XCUIApplication.newCook + ["--appearance-\(appearance)"])
        XCTAssertTrue(app.buttons["open-email-auth"].waitForExistence(timeout: 5))
        capture("opening-titles", appearance: appearance, in: app)
        app.buttons["open-email-auth"].tap()
        XCTAssertTrue(app.textFields["auth-email"].waitForExistence(timeout: 5))
        capture("backstage-pass", appearance: appearance, in: app)
        app.buttons["close-email-auth"].tap()
        app.buttons["sign-in-fake"].tap()
        captureOnboarding(in: app, appearance: appearance)
    }

    @MainActor private func captureOnboarding(in app: XCUIApplication, appearance: String) {
        XCTAssertTrue(app.buttons["onboarding-start"].waitForExistence(timeout: 5))
        capture("meet-your-host", appearance: appearance, in: app)
        app.buttons["onboarding-start"].tap()
        for question in ["diet", "avoid", "kitchen", "cupboard", "cuisines", "experience", "table"] {
            captureQuestion(question, appearance: appearance, in: app)
        }
        XCTAssertTrue(app.buttons["home-scan"].waitForExistence(timeout: 5))
    }

    @MainActor private func captureQuestion(_ question: String, appearance: String, in app: XCUIApplication) {
        XCTAssertTrue(app.element("question-\(question)").waitForExistence(timeout: 5))
        capture(question, appearance: appearance, in: app)
        checkControls(for: question, in: app)
        let next = app.buttons["onboarding-next"]
        if next.exists {
            next.tap()
        } else {
            app.buttons["onboarding-done"].tap()
        }
    }

    @MainActor private func checkControls(for question: String, in app: XCUIApplication) {
        if question == "avoid" { addKnownAllergy(in: app) }
        if question == "cupboard" {
            app.assertCanBeTapped(app.textFields["cupboard-type"])
            app.assertCanBeTapped(app.buttons["cupboard-add"])
        }
    }

    @MainActor private func addKnownAllergy(in app: XCUIApplication) {
        let search = app.textFields["avoid-search"]
        app.assertCanBeTapped(search)
        search.tap()
        search.typeText("Nuts")
        let add = app.buttons["avoid-add-fake-nuts"]
        app.assertCanBeTapped(add)
        add.tap()
        XCTAssertTrue(app.element("choice-fake-nuts").isSelected)
    }

    @MainActor private func capture(_ state: String, appearance: String, in app: XCUIApplication) {
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "\(state)-\(appearance)"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
