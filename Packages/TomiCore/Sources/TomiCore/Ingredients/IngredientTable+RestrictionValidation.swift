/// The checks on the things a cook can choose: avoid items and diets.
extension IngredientTable {
    var avoidItemIssues: [IngredientIssue] {
        var issues: [IngredientIssue] = []
        issues += avoidItems.map(\.id.rawValue).blankPositions.map(IngredientIssue.blankAvoidItemID)
        issues += avoidItems.map(\.id).duplicates.map(IngredientIssue.duplicateAvoidItem)
        issues += avoidItems.filter(\.name.isMissingSourceText).map { .missingAvoidItemName($0.id) }
        issues += avoidItems.filter(\.triggeredBy.isEmpty).map { .avoidItemTriggersNothing($0.id) }
        return issues + undeclaredAvoidItemFactIssues
    }

    var dietIssues: [IngredientIssue] {
        var issues: [IngredientIssue] = []
        issues += diets.map(\.id.rawValue).blankPositions.map(IngredientIssue.blankDietID)
        issues += diets.map(\.id).duplicates.map(IngredientIssue.duplicateDiet)
        issues += diets.filter(isMissingText).map { .missingDietText($0.id) }
        issues += diets.filter(\.excludes.isEmpty).map { .dietExcludesNothing($0.id) }
        return issues + undeclaredDietFactIssues
    }

    private func isMissingText(_ diet: Diet) -> Bool {
        diet.name.isMissingSourceText || diet.summary.isMissingSourceText
    }

    private var undeclaredAvoidItemFactIssues: [IngredientIssue] {
        var issues: [IngredientIssue] = []
        for item in avoidItems {
            for fact in undeclared(item.triggeredBy) {
                issues.append(.undeclaredAvoidItemFact(item.id, fact))
            }
        }
        return issues
    }

    private var undeclaredDietFactIssues: [IngredientIssue] {
        var issues: [IngredientIssue] = []
        for diet in diets {
            for fact in undeclared(diet.excludes) {
                issues.append(.undeclaredDietFact(diet.id, fact))
            }
        }
        return issues
    }
}
