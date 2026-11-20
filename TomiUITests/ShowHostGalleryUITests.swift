import XCTest

final class ShowHostGalleryUITests: XCTestCase {
    override func setUp() {
        continueAfterFailure = false
    }

    @MainActor func testHostPosesInTheMorningShow() async {
        await checkPoses(appearance: "light")
    }

    @MainActor func testHostPosesInTheEveningShow() async {
        await checkPoses(appearance: "dark")
    }

    @MainActor private func checkPoses(appearance: String) async {
        let gallery = ["--show-host-gallery", "--fake-backend", "--store-in-memory", "--appearance-\(appearance)"]
        let app = XCUIApplication.launched(gallery)
        let smiling = app.element("host-idle")
        XCTAssertTrue(smiling.waitForExistence(timeout: 5))
        await checkFigures(in: app)
        await app.buttons["Settings"].assertTomatoRendered()
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "host-poses-\(appearance)"
        attachment.lifetime = .keepAlways
        add(attachment)
    }

    @MainActor private func checkFigures(in app: XCUIApplication) async {
        let states = CompanionGalleryUITests.states + ["head"]
        var drawings = Set<Data>()
        for state in states {
            let figure = app.element("host-\(state)")
            await figure.assertTomatoRendered()
            drawings.insert(figure.screenshot().pngRepresentation)
        }
        XCTAssertEqual(drawings.count, states.count)
    }
}
