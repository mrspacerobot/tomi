import TomiCore

extension ActiveLesson {
    /// A bookmark on the given step, with one swap applied.
    static func fixture(_ lesson: LessonID, onStep step: Int) -> ActiveLesson {
        var active = ActiveLesson(lesson: lesson, revision: 2)
        active.swaps = [AppliedSwap(removed: "butter", added: "olive-oil")]
        active.ingredients = ["garlic", "olive-oil"]
        active.currentStep = step
        return active
    }
}
