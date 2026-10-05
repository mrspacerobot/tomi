import XCTest

extension XCUIApplication {
    /// The smallest side a cook can be asked to tap, in points (AGENTS.md, Accessibility).
    static let minimumTouchTarget: CGFloat = 44

    /// Launches the app on the component gallery of debug builds instead of its first screen.
    @MainActor static func launchingGallery(extraArguments: [String] = []) -> XCUIApplication {
        let app = XCUIApplication()
        app.launchArguments = ["--component-gallery", "--store-in-memory"] + extraArguments
        app.launch()
        XCTAssertTrue(app.staticTexts["gallery-title"].waitForExistence(timeout: 5))
        return app
    }

    /// Any element with the identifier, whatever kind it is: a locked chip is not a button.
    @MainActor func element(_ identifier: String) -> XCUIElement {
        descendants(matching: .any).matching(identifier: identifier).firstMatch
    }

    /// Any element VoiceOver reads these words for. Capitals are styling, so they are not compared.
    @MainActor func element(labelled label: String) -> XCUIElement {
        descendants(matching: .any).matching(NSPredicate(format: "label ==[c] %@", label)).firstMatch
    }

    /// Moves the gallery up by a third of the screen, slowly, so nothing is flung past.
    @MainActor func scrollGalleryDown() {
        let from = coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.6))
        let towards = coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.25))
        from.press(forDuration: 0.05, thenDragTo: towards, withVelocity: .slow, thenHoldForDuration: 0.1)
    }

    /// Brings the element on screen and checks a finger can hit it.
    @MainActor func assertCanBeTapped(_ element: XCUIElement, file: StaticString = #filePath, line: UInt = #line) {
        var scrolls = 0
        while !element.isHittable && scrolls < 60 {
            scrollGalleryDown()
            scrolls += 1
        }
        XCTAssertTrue(element.isHittable, file: file, line: line)
        XCTAssertGreaterThanOrEqual(element.frame.height, Self.minimumTouchTarget, file: file, line: line)
        XCTAssertGreaterThanOrEqual(element.frame.width, Self.minimumTouchTarget, file: file, line: line)
    }
}
