/// The checks on what goes into the dish: the ingredient list and the swaps.
extension Lesson {
    func ingredientIssues(table: IngredientTable) -> [LessonIssue] {
        if ingredients.isEmpty {
            return [.noIngredients]
        }
        var issues = ingredients.map(\.ingredient).duplicates.map(LessonIssue.duplicateIngredient)
        for line in ingredients {
            issues += unknownIngredientIssues(of: line, table: table)
            issues += line.amountIssues
        }
        return issues
    }

    /// An ingredient the table does not list has no facts, so nobody could be told whether they may eat the dish.
    private func unknownIngredientIssues(of line: LessonIngredient, table: IngredientTable) -> [LessonIssue] {
        if table.contains(line.ingredient) {
            return []
        }
        return [.unknownIngredient(line.ingredient)]
    }

    func swapIssues(table: IngredientTable) -> [LessonIssue] {
        var issues: [LessonIssue] = []
        for swap in swaps {
            if !uses(swap.ingredient) {
                issues.append(.swapOfIngredientNotInLesson(swap.ingredient))
            }
            issues += replacementIssues(of: swap, table: table)
            issues += swap.replacement.amountIssues
        }
        return issues
    }

    private func replacementIssues(of swap: LessonSwap, table: IngredientTable) -> [LessonIssue] {
        let replacement = swap.replacement.ingredient
        if uses(replacement) {
            return [.swapReplacementAlreadyInLesson(replacement)]
        }
        if !table.contains(replacement) {
            return [.unknownSwapReplacement(replacement)]
        }
        return []
    }

    /// Whether the ingredient is on the lesson's ingredient list.
    func uses(_ ingredient: IngredientID) -> Bool {
        ingredients.contains { $0.ingredient == ingredient }
    }
}
