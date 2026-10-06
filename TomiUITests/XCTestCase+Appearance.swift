import XCTest

extension XCTestCase {
    /// Foreground the app after a system change; a black launch frame never counts as the dark appearance.
    @MainActor func waitForAppearance(_ appearance: XCUIDevice.Appearance, in app: XCUIApplication) {
        app.activate()
        let expected = NSPredicate { _, _ in
            let brightness = app.screenshot().groundBrightness
            if appearance == .dark { return brightness > 0.03 && brightness < 0.25 }
            return brightness > 0.8
        }
        let settled = XCTNSPredicateExpectation(predicate: expected, object: app)
        wait(for: [settled], timeout: 10)
    }
}
