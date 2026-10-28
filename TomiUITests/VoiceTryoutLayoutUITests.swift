import XCTest

/// The voice try-out at the largest text size: both buttons must stay whole, tappable and on screen.
final class VoiceTryoutLayoutUITests: XCTestCase {
    override func setUp() {
        continueAfterFailure = false
    }

    @MainActor
    func testSpeakAndStopStackAtTheLargestTextSize() {
        let app = launchedTryout(extra: GalleryLayoutUITests.largestTextSize)
        let speak = app.buttons["voice-tryout-speak"]
        let stop = app.buttons["voice-tryout-stop"]

        XCTAssertGreaterThanOrEqual(stop.frame.minY, speak.frame.maxY)
        XCTAssertLessThanOrEqual(speak.frame.maxX, app.frame.maxX)
        XCTAssertLessThanOrEqual(stop.frame.maxX, app.frame.maxX)
    }

    @MainActor
    func testBothButtonsAreAtLeastAsTallAsATouchTarget() {
        let app = launchedTryout(extra: GalleryLayoutUITests.largestTextSize)

        for identifier in ["voice-tryout-speak", "voice-tryout-stop"] {
            XCTAssertGreaterThanOrEqual(app.buttons[identifier].frame.height, XCUIApplication.minimumTouchTarget)
        }
    }

    @MainActor
    func testSpeakAndStopSitSideBySideAtTheDefaultTextSize() {
        let app = launchedTryout(extra: [])
        let speak = app.buttons["voice-tryout-speak"]
        let stop = app.buttons["voice-tryout-stop"]

        XCTAssertGreaterThanOrEqual(stop.frame.minX, speak.frame.maxX)
        XCTAssertEqual(stop.frame.midY, speak.frame.midY, accuracy: 1)
    }

    @MainActor
    private func launchedTryout(extra: [String]) -> XCUIApplication {
        let app = XCUIApplication()
        app.launchArguments = ["-voice-tryout", "-fake-speaker"] + extra
        app.launch()
        XCTAssertTrue(app.buttons["voice-tryout-speak"].waitForExistence(timeout: 5))
        return app
    }
}
