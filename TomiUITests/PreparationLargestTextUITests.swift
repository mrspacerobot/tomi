import XCTest

/// At the largest text size a one-word item must keep its word whole: a row that breaks "Saucepan" into two lines
/// grows taller than the row of a shorter word.
final class PreparationLargestTextUITests: XCTestCase {
    override func setUp() { continueAfterFailure = false }

    @MainActor
    func testOneWordEquipmentKeepsItsWordWholeAtLargestText() {
        let (app, _) = cookingIntroduction(extra: GalleryLayoutUITests.largestTextSize)
        app.buttons["cooking-start"].tap()
        XCTAssertTrue(app.buttons["cooking-steps-begin"].waitForExistence(timeout: 5))
        let saucepan = app.buttons["preparation-equipment-equipment/saucepan"]
        let whisk = app.buttons["preparation-equipment-equipment/whisk"]
        XCTAssertTrue(saucepan.waitForExistence(timeout: 5))
        XCTAssertEqual(saucepan.frame.height, whisk.frame.height, accuracy: 1)
    }
}
