/// Reads a stored bookmark back. One that does not say which lesson, which revision, which step or which swaps
/// is not a bookmark: it gives nil, and the cook starts from tonight's special instead of from a guess.
extension SavedActiveLesson {
    public var activeLesson: ActiveLesson? {
        guard let lesson, let lessonRevision, let currentStep, let swaps else {
            return nil
        }
        var active = ActiveLesson(lesson: LessonID(rawValue: lesson), revision: lessonRevision)
        active.swaps = swaps
        active.ingredients = Set(savedIDs: ingredients)
        active.currentStep = currentStep
        return active
    }

    /// The two saved lists read side by side. Missing lists mean no swaps. Lists of different lengths
    /// no longer say what replaced what, so they give nil.
    private var swaps: [AppliedSwap]? {
        let removed = swappedOut ?? []
        let added = swappedIn ?? []
        guard removed.count == added.count else {
            return nil
        }
        var swaps: [AppliedSwap] = []
        for (out, into) in zip(removed, added) {
            swaps.append(AppliedSwap(removed: IngredientID(rawValue: out), added: IngredientID(rawValue: into)))
        }
        return swaps
    }
}
