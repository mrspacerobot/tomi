/// The checks on what goes into the dish: the ingredient list and the swaps.
/// Whether an ingredient exists, and who may eat it, is checked by Tomi's server against its ingredient table.
extension Lesson {
    func ingredientIssues() -> [LessonIssue] {
        if ingredients.isEmpty {
            return [.noIngredients]
        }
        var issues = ingredients.map(\.ingredient).duplicates.map(LessonIssue.duplicateIngredient)
        for line in ingredients {
            issues += line.amountIssues
        }
        return issues
    }

    func swapIssues() -> [LessonIssue] {
        swaps.flatMap(issues(of:))
    }

    private func issues(of swap: LessonSwap) -> [LessonIssue] {
        var issues: [LessonIssue] = []
        if !uses(swap.ingredient) {
            issues.append(.swapOfIngredientNotInLesson(swap.ingredient))
        }
        if uses(swap.replacement.ingredient) {
            issues.append(.swapReplacementAlreadyInLesson(swap.replacement.ingredient))
        }
        return issues + swap.replacement.amountIssues
    }

    /// Whether the ingredient is on the lesson's ingredient list.
    func uses(_ ingredient: IngredientID) -> Bool {
        ingredients.contains { $0.ingredient == ingredient }
    }
}
