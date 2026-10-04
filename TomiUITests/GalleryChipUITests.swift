import XCTest

/// Chips: every state is said in words to VoiceOver, and a tap changes the state that is said.
final class GalleryChipUITests: XCTestCase {
    override func setUp() {
        continueAfterFailure = false
    }

    @MainActor
    func testTappingACupboardChipTurnsItOffAndOnAgain() {
        let app = XCUIApplication.launchingGallery()
        let chip = app.buttons["gallery-chip-staple"]
        XCTAssertTrue(chip.isSelected)

        chip.tap()
        XCTAssertFalse(chip.isSelected)

        chip.tap()
        XCTAssertTrue(chip.isSelected)
    }

    @MainActor
    func testAChipLeftOutTonightSaysSoInWordsUntilItIsTappedBackIn() {
        let app = XCUIApplication.launchingGallery()
        let chip = app.buttons["gallery-chip-tonight"]
        XCTAssertFalse(chip.isSelected)
        XCTAssertEqual(chip.value as? String, "Left out tonight")

        chip.tap()
        XCTAssertTrue(chip.isSelected)
        XCTAssertNotEqual(chip.value as? String, "Left out tonight")
    }

    @MainActor
    func testALockedChipSaysItIsAlwaysThereAndIsNotAButton() {
        let app = XCUIApplication.launchingGallery()
        let chip = app.element("gallery-chip-locked")

        XCTAssertTrue(chip.exists)
        XCTAssertEqual(chip.label, "Salt")
        XCTAssertEqual(chip.value as? String, "Always there")
        XCTAssertFalse(app.buttons["gallery-chip-locked"].exists)
    }

    @MainActor
    func testTappingARemovableChipRemovesIt() {
        let app = XCUIApplication.launchingGallery()
        let chip = app.buttons["gallery-chip-removable"]
        XCTAssertEqual(chip.label, "Remove lemon")

        chip.tap()
        XCTAssertTrue(chip.waitForNonExistence(timeout: 2))
    }

    @MainActor
    func testAnUnsureChipSaysItIsNotSureAndCanBeRemoved() {
        let app = XCUIApplication.launchingGallery()
        let chip = app.buttons["gallery-chip-unsure"]
        XCTAssertEqual(chip.label, "Remove feta")
        XCTAssertEqual(chip.value as? String, "Not sure")

        chip.tap()
        XCTAssertTrue(chip.waitForNonExistence(timeout: 2))
    }

    @MainActor
    func testUseTagsSayWhereTheIngredientComesFrom() {
        let app = XCUIApplication.launchingGallery()

        XCTAssertEqual(app.element("gallery-tag-fridge").value as? String, "From your fridge")
        XCTAssertEqual(app.element("gallery-tag-cupboard").value as? String, "From your cupboard")
        XCTAssertEqual(app.element("gallery-tag-missing").value as? String, "Missing")
    }
}
