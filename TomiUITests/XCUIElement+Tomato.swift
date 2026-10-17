import XCTest

extension XCUIElement {
    /// Waits until the rendered tomato shows in this element. RealityKit draws its first frame a little
    /// after the view appears, so a single screenshot straight after a tap proves nothing.
    func waitForTomato(timeout: TimeInterval = 15) -> Bool {
        let deadline = Date().addingTimeInterval(timeout)
        while Date() < deadline {
            if screenshot().tomatoCoverage > 0.015 {
                return true
            }
        }
        return false
    }
}
