/// Applying the swaps a lesson lists. Who may eat the swapped dish is decided by Tomi's server, which checks
/// every offer after its swaps; the app never works it out.
extension Lesson {
    /// The lesson with one ingredient replaced. The words of the steps are not changed here.
    public func applying(_ swap: LessonSwap) throws -> Lesson {
        guard let position = ingredients.firstIndex(where: { $0.ingredient == swap.ingredient }) else {
            throw LessonError.swapOfIngredientNotInLesson(swap.ingredient)
        }
        var swapped = self
        swapped.ingredients[position] = swap.replacement
        return swapped
    }

    /// The lesson with these swaps applied in order, each one a swap this lesson lists with its own amounts.
    /// A swap the lesson does not list throws: an offer or a bookmark cannot bring an ingredient of its own.
    public func applying(listed swaps: [AppliedSwap]) throws -> Lesson {
        var adapted = self
        for applied in swaps {
            guard let listed = listedSwap(applied) else {
                throw LessonError.swapNotListed(applied)
            }
            adapted = try adapted.applying(listed)
        }
        return adapted
    }

    /// The swap of this lesson that takes out and puts in these ingredients, or nil when it lists none.
    public func listedSwap(_ applied: AppliedSwap) -> LessonSwap? {
        swaps.first { swap in
            swap.ingredient == applied.removed && swap.replacement.ingredient == applied.added
        }
    }
}
