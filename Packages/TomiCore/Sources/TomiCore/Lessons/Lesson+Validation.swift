/// The checks a lesson must pass before a cook may see it. Every library build and every load runs them.
/// A lesson is checked against the lists of the same library: the skill catalog, the ingredient table
/// and the equipment list.
extension Lesson {
    /// Every problem in the lesson, empty when it is fit to serve.
    public func issues(in lists: LibraryLists) -> [LessonIssue] {
        var issues = identityIssues(catalog: lists.catalog)
        issues += numberIssues
        issues += contentIssues(in: lists)
        issues += stepIssues
        issues += quiz.issues
        issues += swapIssues(table: lists.ingredientTable)
        issues += textIssues
        return issues
    }

    /// What goes into the dish, what the kitchen must have, and the main food the scenes draw.
    private func contentIssues(in lists: LibraryLists) -> [LessonIssue] {
        var issues = ingredientIssues(table: lists.ingredientTable)
        issues += equipmentIssues(list: lists.equipmentList)
        issues += mainIssues
        return issues
    }

    private func identityIssues(catalog: SkillCatalog) -> [LessonIssue] {
        var issues: [LessonIssue] = []
        if id.rawValue.isBlank {
            issues.append(.blankID)
        }
        issues += skillIssues(catalog: catalog)
        if cuisine.rawValue.isBlank {
            issues.append(.blankCuisine)
        }
        return issues
    }

    private var mainIssues: [LessonIssue] {
        if main == nil {
            return [.unknownMain(mainName)]
        }
        return []
    }

    /// The lesson must teach a level that its skill really has, or a finished cook would count for nothing.
    private func skillIssues(catalog: SkillCatalog) -> [LessonIssue] {
        guard let taughtSkill = catalog.skill(skill) else {
            return [.unknownSkill(skill)]
        }
        let skillHasLevel = taughtSkill.levels.contains { $0.number == level }
        if skillHasLevel {
            return []
        }
        return [.unknownLevel(skill, level)]
    }

    private var numberIssues: [LessonIssue] {
        var issues: [LessonIssue] = []
        if revision < 1 {
            issues.append(.revisionNotPositive)
        }
        if minutes < 1 {
            issues.append(.minutesNotPositive)
        }
        return issues
    }

    private var stepIssues: [LessonIssue] {
        if steps.isEmpty {
            return [.noSteps]
        }
        var issues: [LessonIssue] = []
        for (position, step) in steps.enumerated() {
            issues += step.issues(at: position)
        }
        return issues
    }
}
