import Testing

@testable import TomiCore

/// A lesson in progress is built again from the library before it is shown.
/// Whether the cook may still eat it is kept safe elsewhere: the app forgets the bookmark whenever the cook's
/// diet or avoid list changes (see `CookProfileRestrictionTests`).
@Suite struct ActiveLessonResumeTests {
    let lessons = [Lesson.fixtureWithOliveOilSwap()]
    let active = ActiveLesson.fixtureOnTheSecondStepWithOliveOil()

    @Test func theLessonComesBackWithItsSwapsAndItsStep() throws {
        let resumed = try active.resumed(from: lessons)
        #expect(resumed.lesson.ingredients.map(\.ingredient) == ["garlic", "olive-oil"])
        #expect(resumed.currentStep == 1)
        #expect(resumed.ingredients == ["garlic", "olive-oil"])
    }

    @Test func aLessonWithoutSwapsComesBackAsWritten() throws {
        var plain = active
        plain.swaps = []
        #expect(try plain.resumed(from: lessons).lesson == lessons[0])
    }

    @Test func aLessonTheLibraryNoLongerHasIsNotResumed() {
        #expect(throws: ResumeError.lessonNotInLibrary("garlic-butter")) {
            try active.resumed(from: [])
        }
    }

    @Test func aLessonCorrectedSinceItWasStartedIsNotResumed() {
        var corrected = Lesson.fixtureWithOliveOilSwap()
        corrected.revision = 2
        #expect(throws: ResumeError.lessonNotInLibrary("garlic-butter")) {
            try active.resumed(from: [corrected])
        }
    }

    @Test func aSwapTheLessonDoesNotListIsNotApplied() {
        var invented = active
        invented.swaps = [AppliedSwap(removed: "butter", added: "garlic")]
        #expect(throws: ResumeError.swapNotInLesson(invented.swaps[0])) {
            try invented.resumed(from: lessons)
        }
    }

    @Test(arguments: [-1, 2, 40])
    func aStepTheLessonDoesNotHaveIsNotResumed(step: Int) {
        var lost = active
        lost.currentStep = step
        #expect(throws: ResumeError.stepNotInLesson(step)) {
            try lost.resumed(from: lessons)
        }
    }
}
