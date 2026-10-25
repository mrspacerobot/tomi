import XCTest

extension XCUIElement {
    /// Waits until the drawn tomato shows in this element. A screen change animates in, so a single
    /// screenshot straight after a tap proves nothing.
    @MainActor func waitForTomato(timeout: TimeInterval = 15) async -> Bool {
        let deadline = Date().addingTimeInterval(timeout)
        while Date() < deadline {
            // Let the compositor present a new frame before capturing, including after a screen change.
            try? await Task.sleep(for: .seconds(min(1, deadline.timeIntervalSinceNow)))
            guard Date() < deadline else { return false }
            if screenshot().tomatoCoverage > 0.015 {
                return true
            }
        }
        return false
    }

    @MainActor func assertTomatoRendered(timeout: TimeInterval = 15) async {
        let rendered = await waitForTomato(timeout: timeout)
        XCTAssertTrue(rendered)
    }
}
