/// The checks a lesson must pass before the player may open it: what the app needs to cook it offline.
/// It is checked against the skill catalog, so a finished cook counts where it was taught.
/// The library itself, with its ingredient table and equipment list, is validated by Tomi's server.
extension Lesson {
    /// Every problem in the lesson, empty when it is fit to cook.
    public func issues(in catalog: SkillCatalog) -> [LessonIssue] {
        var issues = identityIssues(catalog: catalog)
        issues += numberIssues
        issues += ingredientIssues()
        issues += mainIssues
        issues += stepIssues
        issues += quiz.issues
        issues += swapIssues()
        issues += textIssues
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
