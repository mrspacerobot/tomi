extension LessonIngredient {
    /// The problems of both amounts: each must be more than nothing, in a unit of its own system.
    var amountIssues: [LessonIssue] {
        var issues: [LessonIssue] = []
        for units in Units.allCases {
            issues += amountIssues(in: units)
        }
        return issues
    }

    private func amountIssues(in units: Units) -> [LessonIssue] {
        let amount = amount(in: units)
        var issues: [LessonIssue] = []
        if !amount.isPositive {
            issues.append(.amountNotPositive(ingredient, units))
        }
        if !amount.unit.belongs(to: units) {
            issues.append(.unitOutsideSystem(ingredient, units))
        }
        return issues
    }
}
