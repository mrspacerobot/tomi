@testable import TomiCore

extension ActiveLesson {
    /// A bookmark in the fixture lesson: butter swapped for olive oil, on the second of its two steps.
    static func fixtureOnTheSecondStepWithOliveOil() -> ActiveLesson {
        var active = ActiveLesson(lesson: Lesson.fixture().id, revision: Lesson.fixture().revision)
        active.swaps = [AppliedSwap(removed: "butter", added: "olive-oil")]
        active.ingredients = ["garlic", "olive-oil"]
        active.currentStep = 1
        return active
    }
}

extension Lesson {
    /// The fixture lesson, listing the swap of butter for olive oil.
    static func fixtureWithOliveOilSwap() -> Lesson {
        var lesson = Lesson.fixture()
        lesson.swaps = [.fixture(replacing: "butter", with: "olive-oil")]
        return lesson
    }
}
