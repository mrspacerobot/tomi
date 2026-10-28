import XCTest

/// Finishing the steps of a recipe writes the cook to the phone, where it waits for the server: Home names it after
/// the app is opened again offline.
final class CookingRecordUITests: XCTestCase {
    private static let offline = ["--fake-cook-entries-offline"]

    override func setUp() { continueAfterFailure = false }

    @MainActor
    func testAFinishedCookWaitsOnThePhoneUntilTheServerCanCountIt() {
        finishACook()
        let home = XCUIApplication.launched(
            XCUIApplication.returningCook + ["--store-ui-test-file"] + Self.offline
        )
        let note = home.staticTexts["home-progress-note"]
        XCTAssertTrue(note.waitForExistence(timeout: 5))
        // The known state holds six unsent cooks and a snapshot; the cook just made is the seventh.
        XCTAssertTrue(note.label.hasPrefix("7 cooks"), note.label)
    }

    @MainActor
    func testAStoppedSaveKeepsTheCookOnTheLastStepUntilRetry() {
        let args = Self.offline + ["--seed-known-state", "--store-fail-first-cook-save"]
        let app = cookingIntroduction(store: "--store-ui-test-file", extra: args).0
        beginAndWalkAllSteps(app)
        app.buttons["cooking-steps-finish"].tap()
        XCTAssertTrue(app.alerts.staticTexts["Tomi could not save your cook"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.element("cooking-steps").exists)
        app.alerts.buttons["Try again"].tap()
        XCTAssertTrue(app.element("suggestion-detail").waitForExistence(timeout: 5))
        app.terminate()
        assertSevenCooksAreWaiting()
    }

    @MainActor
    func testLeavingEarlyWaitsForTheStoppedCookToBeSaved() {
        let args = Self.offline + ["--seed-known-state", "--store-fail-first-cook-save"]
        let app = cookingIntroduction(store: "--store-in-memory", extra: args).0
        beginAndWalkAllSteps(app)
        app.buttons["cooking-step-previous"].tap()
        app.buttons["cooking-steps-back"].tap()
        XCTAssertTrue(app.alerts.staticTexts["Tomi could not save your cook"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.element("cooking-steps").exists)
        app.alerts.buttons["Try again"].tap()
        XCTAssertTrue(app.buttons["cooking-steps-begin"].waitForExistence(timeout: 5))
    }

    @MainActor
    func testACookCanStayAfterAStopSaveFailsAndThenFinish() {
        let args = Self.offline + ["--seed-known-state", "--store-fail-first-cook-save"]
        let app = cookingIntroduction(store: "--store-ui-test-file", extra: args).0
        stayAfterAStopFails(app)
        app.buttons["cooking-step-next"].tap()
        app.buttons["cooking-steps-finish"].tap()
        XCTAssertTrue(app.element("suggestion-detail").waitForExistence(timeout: 5))
        app.terminate()
        assertSevenCooksAreWaiting()
    }

    @MainActor private func stayAfterAStopFails(_ app: XCUIApplication) {
        beginAndWalkAllSteps(app)
        app.buttons["cooking-step-previous"].tap()
        app.buttons["cooking-steps-back"].tap()
        XCTAssertTrue(app.alerts.buttons["Stay here"].waitForExistence(timeout: 5))
        app.alerts.buttons["Stay here"].tap()
    }

    @MainActor
    func testTheQuizWaitsForTheFinishedCookToBeSaved() {
        let args = FakeQuizLaunch.arguments + ["--store-fail-first-cook-save"]
        let app = cookingIntroduction(extra: args).0
        beginAndWalkAllSteps(app)
        app.buttons["cooking-quiz-open"].tap()
        XCTAssertTrue(app.alerts.staticTexts["Tomi could not save your cook"].waitForExistence(timeout: 5))
        XCTAssertFalse(app.element("cooking-quiz").exists)
        app.alerts.buttons["Try again"].tap()
        XCTAssertTrue(app.element("cooking-quiz").waitForExistence(timeout: 5))
    }

    @MainActor private func assertSevenCooksAreWaiting() {
        let home = XCUIApplication.launched(XCUIApplication.returningCook + ["--store-ui-test-file"] + Self.offline)
        let note = home.staticTexts["home-progress-note"]
        XCTAssertTrue(note.waitForExistence(timeout: 5))
        XCTAssertTrue(note.label.hasPrefix("7 cooks"), note.label)
    }

    @MainActor private func finishACook() {
        let cooking = cookingIntroduction(store: "--store-ui-test-file", extra: Self.offline + ["--seed-known-state"])
            .0
        beginAndWalkAllSteps(cooking)
        cooking.buttons["cooking-steps-finish"].tap()
        XCTAssertTrue(cooking.element("suggestion-detail").waitForExistence(timeout: 5))
        cooking.terminate()
    }
}
