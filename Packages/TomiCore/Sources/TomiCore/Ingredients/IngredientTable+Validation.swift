/// The checks a hand-written table must pass. Every library build and every load runs them.
/// The compiler checks none of this, so these rules are what keeps a mistyped fact from reading as a safe one.
extension IngredientTable {
    /// Every problem in the table, empty when it is fit to answer.
    public var issues: [IngredientIssue] {
        ingredientIssues + factIssues + avoidItemIssues + dietIssues
    }

    private var ingredientIssues: [IngredientIssue] {
        var issues: [IngredientIssue] = []
        if ingredients.isEmpty {
            issues.append(.noIngredients)
        }
        issues += ingredients.map(\.id.rawValue).blankPositions.map(IngredientIssue.blankIngredientID)
        issues += ingredients.map(\.id).duplicates.map(IngredientIssue.duplicateIngredient)
        issues += ingredients.filter(\.name.isMissingSourceText).map { .missingIngredientName($0.id) }
        return issues + undeclaredIngredientFactIssues
    }

    private var undeclaredIngredientFactIssues: [IngredientIssue] {
        var issues: [IngredientIssue] = []
        for ingredient in ingredients {
            for fact in undeclared(ingredient.facts) {
                issues.append(.undeclaredIngredientFact(ingredient.id, fact))
            }
        }
        return issues
    }

    private var factIssues: [IngredientIssue] {
        let blank = facts.map(\.rawValue).blankPositions.map(IngredientIssue.blankFactID)
        let repeated = facts.duplicates.map(IngredientIssue.duplicateFact)
        return blank + repeated
    }

    /// The facts in a set that the table's `facts` list does not declare, sorted so reports are stable.
    func undeclared(_ used: Set<IngredientFactID>) -> [IngredientFactID] {
        used.subtracting(facts).sorted()
    }
}
