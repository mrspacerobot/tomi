import Testing

@testable import TomiCore

/// The bookmark of the lesson in progress, to the store and back.
@Suite struct SavedActiveLessonTests {
    @Test func aBookmarkSurvivesBeingSavedAndReadBack() {
        let active = ActiveLesson.fixtureOnTheSecondStepWithOliveOil()
        #expect(SavedActiveLesson(active).activeLesson == active)
    }

    @Test func everyFieldIsWrittenUnderItsOwnName() {
        let saved = SavedActiveLesson(.fixtureOnTheSecondStepWithOliveOil())
        #expect(saved.lesson == "garlic-butter")
        #expect(saved.lessonRevision == 1)
        #expect(saved.swappedOut == ["butter"])
        #expect(saved.swappedIn == ["olive-oil"])
        #expect(saved.ingredients == ["garlic", "olive-oil"])
        #expect(saved.currentStep == 1)
    }

    @Test func aRecordWithNoFieldsIsNotABookmark() {
        #expect(SavedActiveLesson().activeLesson == nil)
    }

    @Test func aRecordWithoutItsLessonRevisionOrStepIsNotABookmark() {
        var withoutLesson = SavedActiveLesson(.fixtureOnTheSecondStepWithOliveOil())
        withoutLesson.lesson = nil
        var withoutRevision = SavedActiveLesson(.fixtureOnTheSecondStepWithOliveOil())
        withoutRevision.lessonRevision = nil
        var withoutStep = SavedActiveLesson(.fixtureOnTheSecondStepWithOliveOil())
        withoutStep.currentStep = nil
        #expect(withoutLesson.activeLesson == nil)
        #expect(withoutRevision.activeLesson == nil)
        #expect(withoutStep.activeLesson == nil)
    }

    @Test func missingListsMeanNoSwapsAndNoIngredients() {
        var saved = SavedActiveLesson(.fixtureOnTheSecondStepWithOliveOil())
        saved.swappedOut = nil
        saved.swappedIn = nil
        saved.ingredients = nil
        #expect(saved.activeLesson?.swaps == [])
        #expect(saved.activeLesson?.ingredients == [])
    }

    /// Dropping the swap would bring the butter back for a cook who cannot eat it.
    @Test func swapListsThatDoNotLineUpAreNotABookmark() {
        var saved = SavedActiveLesson(.fixtureOnTheSecondStepWithOliveOil())
        saved.swappedIn = nil
        #expect(saved.activeLesson == nil)
    }
}
