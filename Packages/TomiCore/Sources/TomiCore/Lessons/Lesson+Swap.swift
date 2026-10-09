/// Applying a swap the lesson lists. Who may eat the swapped dish is decided by Tomi's server, which checks
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
}
