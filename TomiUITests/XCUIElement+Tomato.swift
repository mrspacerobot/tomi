import XCTest

extension XCUIElement {
    /// Waits until the rendered tomato shows in this element. RealityKit draws its first frame a little
    /// after the view appears, so a single screenshot straight after a tap proves nothing.
    @MainActor func waitForTomato(timeout: TimeInterval = 15) async -> Bool {
        let deadline = Date().addingTimeInterval(timeout)
        while Date() < deadline {
            if screenshot().tomatoCoverage > 0.015 {
                return true
            }
            try? await Task.sleep(for: .milliseconds(200))
        }
        return false
    }

    @MainActor func assertTomatoRendered(timeout: TimeInterval = 15) async {
        let rendered = await waitForTomato(timeout: timeout)
        XCTAssertTrue(rendered)
    }
}
