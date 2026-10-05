/// Picking a lesson up again after the app was closed.
extension ActiveLesson {
    /// The dish as the cook left it: the library's lesson with the same swaps applied again.
    /// It is checked against the cook's diet and avoid list as they are now, because both may have changed
    /// since the lesson was started, and a restriction the table does not list refuses it.
    public func resumed(
        from lessons: [Lesson],
        for preferences: CookPreferences,
        in table: IngredientTable
    ) throws -> ResumedLesson {
        let adapted = try adaptedLesson(from: lessons)
        guard adapted.steps.indices.contains(currentStep) else {
            throw ResumeError.stepNotInLesson(currentStep)
        }
        guard try adapted.isAllowed(by: preferences, in: table) else {
            throw ResumeError.notAllowedForTheCook
        }
        return ResumedLesson(lesson: adapted, ingredients: ingredients, currentStep: currentStep)
    }

    private func adaptedLesson(from lessons: [Lesson]) throws -> Lesson {
        guard let written = lessons.first(where: { $0.id == lesson && $0.revision == revision }) else {
            throw ResumeError.lessonNotInLibrary(lesson)
        }
        var adapted = written
        for applied in swaps {
            adapted = try adapted.applying(listedSwap(applied, in: written))
        }
        return adapted
    }

    /// Only a swap the lesson lists may be applied: a bookmark cannot bring an ingredient of its own.
    private func listedSwap(_ applied: AppliedSwap, in written: Lesson) throws -> LessonSwap {
        let listed = written.swaps.first { swap in
            swap.ingredient == applied.removed && swap.replacement.ingredient == applied.added
        }
        guard let listed else {
            throw ResumeError.swapNotInLesson(applied)
        }
        return listed
    }
}
