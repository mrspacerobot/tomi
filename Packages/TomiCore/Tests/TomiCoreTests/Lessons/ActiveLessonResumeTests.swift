import Testing

@testable import TomiCore

/// A lesson in progress is built again from the library and checked again before it is shown.
@Suite struct ActiveLessonResumeTests {
    let table = IngredientTable.fixture(ingredients: [
        .fixture("garlic"), .fixture("butter", contains: ["dairy"]), .fixture("olive-oil"),
    ])
    let lessons = [Lesson.fixtureWithOliveOilSwap()]
    let active = ActiveLesson.fixtureOnTheSecondStepWithOliveOil()

    @Test func theLessonComesBackWithItsSwapsAndItsStep() throws {
        let resumed = try active.resumed(from: lessons, for: .fixture(diet: "vegan"), in: table)
        #expect(resumed.lesson.ingredients.map(\.ingredient) == ["garlic", "olive-oil"])
        #expect(resumed.currentStep == 1)
        #expect(resumed.ingredients == ["garlic", "olive-oil"])
    }

    @Test func aLessonWithoutSwapsComesBackAsWritten() throws {
        var plain = active
        plain.swaps = []
        #expect(try plain.resumed(from: lessons, for: CookPreferences(), in: table).lesson == lessons[0])
    }

    @Test func aLessonTheLibraryNoLongerHasIsNotResumed() {
        #expect(throws: ResumeError.lessonNotInLibrary("garlic-butter")) {
            try active.resumed(from: [], for: CookPreferences(), in: table)
        }
    }

    @Test func aLessonCorrectedSinceItWasStartedIsNotResumed() {
        var corrected = Lesson.fixtureWithOliveOilSwap()
        corrected.revision = 2
        #expect(throws: ResumeError.lessonNotInLibrary("garlic-butter")) {
            try active.resumed(from: [corrected], for: CookPreferences(), in: table)
        }
    }

    @Test func aSwapTheLessonDoesNotListIsNotApplied() {
        var invented = active
        invented.swaps = [AppliedSwap(removed: "butter", added: "garlic")]
        #expect(throws: ResumeError.swapNotInLesson(invented.swaps[0])) {
            try invented.resumed(from: lessons, for: CookPreferences(), in: table)
        }
    }

    @Test(arguments: [-1, 2, 40])
    func aStepTheLessonDoesNotHaveIsNotResumed(step: Int) {
        var lost = active
        lost.currentStep = step
        #expect(throws: ResumeError.stepNotInLesson(step)) {
            try lost.resumed(from: lessons, for: CookPreferences(), in: table)
        }
    }

    /// The cook started the buttery dish, then said they avoid dairy. The dish must not come back.
    @Test func aDishTheCookMayNoLongerEatIsNotResumed() {
        var buttery = active
        buttery.swaps = []
        #expect(throws: ResumeError.notAllowedForTheCook) {
            try buttery.resumed(from: lessons, for: .fixture(diet: nil, avoid: ["dairy"]), in: table)
        }
    }

    @Test func aRestrictionTheTableDoesNotListRefusesTheLesson() {
        #expect(throws: ResumeError.notAllowedForTheCook) {
            try active.resumed(from: lessons, for: .fixture(diet: DietID.unreadable), in: table)
        }
    }
}
