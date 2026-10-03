/// The checks a hand-written table must pass. Every library build and every load runs them.
/// There is no check that facts and avoid items agree, because the avoid items are not written: they are derived.
extension IngredientTable {
    /// Every problem in the table, empty when it is fit to answer.
    public var issues: [IngredientIssue] {
        emptyIssues + blankIDIssues + duplicateIssues + nameIssues + unknownFactIssues
    }

    private var emptyIssues: [IngredientIssue] {
        if ingredients.isEmpty {
            return [.noIngredients]
        }
        return []
    }

    private var blankIDIssues: [IngredientIssue] {
        ingredients.map(\.id.rawValue).blankPositions.map(IngredientIssue.blankIngredientID)
    }

    private var duplicateIssues: [IngredientIssue] {
        ingredients.map(\.id).duplicates.map(IngredientIssue.duplicateIngredient)
    }

    private var nameIssues: [IngredientIssue] {
        let nameless = ingredients.filter(\.name.isMissingSourceText)
        return nameless.map { IngredientIssue.missingIngredientName($0.id) }
    }

    private var unknownFactIssues: [IngredientIssue] {
        var issues: [IngredientIssue] = []
        for ingredient in ingredients {
            for value in ingredient.unknownFacts {
                issues.append(.unknownFact(ingredient.id, value))
            }
        }
        return issues
    }
}
