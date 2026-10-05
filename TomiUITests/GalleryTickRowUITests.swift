import XCTest

/// Tick rows: a question with one answer moves its tick, a question with several keeps each tick by itself.
final class GalleryTickRowUITests: XCTestCase {
    override func setUp() {
        continueAfterFailure = false
    }

    @MainActor
    func testTickingAnotherRowOfASingleChoiceMovesTheTick() {
        let app = XCUIApplication.launchingGallery()
        let first = app.buttons["gallery-single-0"]
        let second = app.buttons["gallery-single-1"]
        XCTAssertFalse(first.isSelected)

        first.tap()
        XCTAssertTrue(first.isSelected)

        second.tap()
        XCTAssertTrue(second.isSelected)
        XCTAssertFalse(first.isSelected)
    }

    @MainActor
    func testRowsOfAMultipleChoiceAreTickedAndUntickedOneByOne() {
        let app = XCUIApplication.launchingGallery()
        let first = app.buttons["gallery-multiple-0"]
        let second = app.buttons["gallery-multiple-1"]

        assertOnlyFirstIsSelected(first, second)

        second.tap()
        XCTAssertTrue(first.isSelected)
        XCTAssertTrue(second.isSelected)

        first.tap()
        assertOnlyFirstIsSelected(second, first)
    }

    @MainActor
    private func assertOnlyFirstIsSelected(_ first: XCUIElement, _ second: XCUIElement) {
        XCTAssertTrue(first.isSelected)
        XCTAssertFalse(second.isSelected)
    }

    @MainActor
    func testATickRowReadsItsNameAndNoteAndIsLargeEnoughToTap() {
        let app = XCUIApplication.launchingGallery()
        let row = app.buttons["gallery-multiple-0"]

        XCTAssertEqual(row.label, "Oven, roasting")
        app.assertCanBeTapped(row)
    }
}
