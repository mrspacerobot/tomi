import XCTest

/// Home shows the progress Tomi's server sent, and says kindly when cooks have not counted yet.
/// The fake server's returning cook has 350 XP, the rank Commis and one technique mastered.
final class ServerProgressUITests: XCTestCase {
    private static let returningTotals = "350 XP; 1 technique mastered"

    override func setUp() {
        continueAfterFailure = false
    }

    @MainActor
    func testAReturningCookSeesTheServersRankAndXP() {
        let app = launch(["--store-in-memory", "--fake-progress-returning"])
        let strip = app.otherElements["home-progress-strip"]
        XCTAssertTrue(strip.waitForExistence(timeout: 5))
        XCTAssertEqual(strip.value as? String, Self.returningTotals)
        XCTAssertTrue(element(labelled: "Commis", in: app).exists)
        XCTAssertTrue(element(labelled: "350 XP earned", in: app).exists)
        XCTAssertFalse(app.staticTexts["home-progress-note"].exists)
    }

    @MainActor
    func testUnsentCooksAreNamedOfflineAndCountOnceBackOnline() {
        let offline = launch(["--store-ui-test-file", "--seed-known-state", "--fake-cook-entries-offline"])
        assertProgress(in: offline, note: "will count when you're back online")
        offline.terminate()

        let online = launch(["--store-ui-test-file"])
        assertProgress(in: online, note: nil)
        online.terminate()

        // Offline again, the note would name any cook still on the phone: there is none.
        let offlineAgain = launch(["--store-ui-test-file", "--fake-cook-entries-offline"])
        assertProgress(in: offlineAgain, note: nil)
    }

    @MainActor
    func testANewCookOfflineSeesWhenProgressShowsAndNoNumbers() {
        let app = launch(["--store-in-memory", "--fake-cook-entries-offline"])
        let note = app.staticTexts["home-progress-note"]
        XCTAssertTrue(note.waitForExistence(timeout: 5))
        XCTAssertEqual(note.label, "Your progress will show when you're online.")
        XCTAssertFalse(app.otherElements["home-progress-strip"].exists)
    }

    /// The server's XP stays as it was sent: unsent cooks are only counted in the note.
    @MainActor
    private func assertProgress(in app: XCUIApplication, note words: String?) {
        let strip = app.otherElements["home-progress-strip"]
        XCTAssertTrue(strip.waitForExistence(timeout: 5))
        XCTAssertEqual(strip.value as? String, Self.returningTotals)
        let note = app.staticTexts["home-progress-note"]
        guard let words else {
            // The fake server answers at once, so a note that would come has come well within this wait.
            XCTAssertFalse(note.waitForExistence(timeout: 2))
            return
        }
        XCTAssertTrue(note.waitForExistence(timeout: 5))
        XCTAssertTrue(note.label.hasSuffix(words + "."), note.label)
    }

    @MainActor
    private func element(labelled words: String, in app: XCUIApplication) -> XCUIElement {
        app.descendants(matching: .any).matching(NSPredicate(format: "label CONTAINS %@", words)).firstMatch
    }

    @MainActor
    private func launch(_ arguments: [String]) -> XCUIApplication {
        XCUIApplication.launched(XCUIApplication.returningCook + arguments)
    }
}
