import XCTest

/// The cupboard question in settings, against the fake server: the everyday staples as chips, the cook's own
/// extras, and the first save that tells the server the question was answered.
final class CupboardUITests: XCTestCase {
    override func setUp() {
        continueAfterFailure = false
    }

    @MainActor
    func testTheCupboardShowsTheEverydayStaplesAndNotEveryIngredient() {
        let app = openCupboard()
        XCTAssertTrue(app.buttons["cupboard-fake-rice"].exists)
        let chips = app.buttons.matching(NSPredicate(format: "identifier BEGINSWITH 'cupboard-fake'"))
        XCTAssertLessThanOrEqual(chips.count, 10)
    }

    @MainActor
    func testUntilAnsweredTheChipsShowWhatTheServerAssumes() {
        let app = openCupboard()
        XCTAssertTrue(app.buttons["cupboard-fake-salt"].isSelected)
        XCTAssertFalse(app.buttons["cupboard-fake-rice"].isSelected)
    }

    @MainActor
    func testTickingAndUntickingSaves() {
        let app = openCupboard()
        app.buttons["cupboard-fake-rice"].tap()
        app.buttons["cupboard-fake-salt"].tap()
        saveAndReopen(app)
        XCTAssertTrue(app.buttons["cupboard-fake-rice"].isSelected)
        XCTAssertFalse(app.buttons["cupboard-fake-salt"].isSelected)
    }

    @MainActor
    func testSavingWithoutChangesStillAnswersTheQuestion() {
        let app = openCupboard()
        saveAndReopen(app)
        app.buttons["cupboard-fake-pepper"].tap()
        saveAndReopen(app)
        XCTAssertFalse(app.buttons["cupboard-fake-pepper"].isSelected)
        XCTAssertTrue(app.buttons["cupboard-fake-salt"].isSelected)
    }

    @MainActor
    func testATypedWordBecomesARemovableChip() {
        let app = openCupboard()
        XCTAssertFalse(app.buttons["cupboard-extra-fake-cumin"].exists)
        add("cumin", in: app)
        XCTAssertTrue(app.buttons["cupboard-extra-fake-cumin"].waitForExistence(timeout: 5))
        saveAndReopen(app)
        XCTAssertTrue(app.buttons["cupboard-extra-fake-cumin"].exists)
        app.buttons["cupboard-extra-fake-cumin"].tap()
        XCTAssertFalse(app.buttons["cupboard-extra-fake-cumin"].exists)
    }

    @MainActor
    func testTheCountFollowsTheChips() {
        let app = openCupboard()
        XCTAssertTrue(app.staticTexts["3 staples saved."].exists)
        app.buttons["cupboard-fake-salt"].tap()
        app.buttons["cupboard-fake-oil"].tap()
        XCTAssertTrue(app.staticTexts["1 staple saved."].exists)
    }

    @MainActor private func openCupboard() -> XCUIApplication {
        let app = XCUIApplication.launched(XCUIApplication.returningCook + ["--store-in-memory"])
        open(app)
        return app
    }

    @MainActor private func open(_ app: XCUIApplication) {
        if app.buttons["home-settings"].waitForExistence(timeout: 5) {
            app.buttons["home-settings"].tap()
        }
        XCTAssertTrue(app.element("settings-question-cupboard").waitForExistence(timeout: 5))
        app.element("settings-question-cupboard").tap()
        XCTAssertTrue(app.buttons["cupboard-fake-salt"].waitForExistence(timeout: 5))
    }

    /// Saves, which closes the question, and opens it again to see what the server kept.
    @MainActor private func saveAndReopen(_ app: XCUIApplication) {
        app.buttons["settings-save"].tap()
        open(app)
    }

    @MainActor private func add(_ word: String, in app: XCUIApplication) {
        app.textFields["cupboard-type"].tap()
        app.textFields["cupboard-type"].typeText(word)
        app.buttons["cupboard-add"].tap()
    }
}
