/// Picking a lesson up again after the app was closed.
extension ActiveLesson {
    /// The dish as the cook left it: the library's lesson with the same swaps applied again.
    /// Whether the cook may still eat it is not decided here: the app forgets the bookmark whenever the cook's
    /// diet or avoid list changes (`CookProfile.hasSameRestrictions(as:)`), because only the server can check a dish.
    public func resumed(from lessons: [Lesson]) throws -> ResumedLesson {
        let adapted = try adaptedLesson(from: lessons)
        guard adapted.steps.indices.contains(currentStep) else {
            throw ResumeError.stepNotInLesson(currentStep)
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
