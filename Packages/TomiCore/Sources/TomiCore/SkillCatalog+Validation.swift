/// The checks the compiler made when the menu was code. Every library build and every load runs them.
extension SkillCatalog {
    /// Every problem in the catalog, empty when it is fit to serve.
    public var issues: [CatalogIssue] {
        blankIDIssues + duplicateIssues + courseIssues + prerequisiteIssues + levelIssues + textIssues
    }

    private var duplicateIssues: [CatalogIssue] {
        duplicates(in: courses.map(\.id)).map(CatalogIssue.duplicateCourse)
            + duplicates(in: skills.map(\.id)).map(CatalogIssue.duplicateSkill)
    }

    private var courseIssues: [CatalogIssue] {
        let known = Set(courses.map(\.id))
        let unknown = skills.filter { !known.contains($0.course) }.map { CatalogIssue.unknownCourse($0.id, $0.course) }
        let empty = courses.filter { skills(in: $0.id).isEmpty }.map { CatalogIssue.emptyCourse($0.id) }
        let none: [CatalogIssue] = courses.isEmpty ? [.noCourses] : []
        return none + unknown + empty + courseOrderIssues
    }

    /// Skills of one course sit together, and courses follow each other in menu order.
    /// Skills in an unknown course are already reported, so they are left out rather than blamed on their neighbours.
    private var courseOrderIssues: [CatalogIssue] {
        let rank = firstPositions(of: courses.map(\.id))
        let placed = skills.compactMap { skill in rank[skill.course].map { (id: skill.id, rank: $0) } }
        return placed.indices.dropFirst()
            .filter { placed[$0].rank < placed[$0 - 1].rank }
            .map { CatalogIssue.skillOutOfCourseOrder(placed[$0].id) }
    }

    private var prerequisiteIssues: [CatalogIssue] {
        let position = firstPositions(of: skills.map(\.id))
        return skills.enumerated().flatMap { index, skill in
            skill.prerequisites.compactMap { prerequisiteIssue(skill.id, needs: $0, at: (index, position[$0])) }
        }
    }

    private func prerequisiteIssue(
        _ skill: SkillID,
        needs prerequisite: SkillID,
        at positions: (skill: Int, prerequisite: Int?)
    ) -> CatalogIssue? {
        guard let prerequisitePosition = positions.prerequisite else {
            return .unknownPrerequisite(skill, prerequisite)
        }
        return prerequisitePosition < positions.skill ? nil : .prerequisiteNotEarlier(skill, prerequisite)
    }

    private var levelIssues: [CatalogIssue] {
        skills.compactMap { skill in
            if skill.levels.isEmpty { return .noLevels(skill.id) }
            let numbers = skill.levels.map(\.number)
            return numbers == Array(1...numbers.count) ? nil : .levelsOutOfOrder(skill.id)
        }
    }

    private var textIssues: [CatalogIssue] {
        let courseTitles = courses.filter(\.title.isMissingSourceText).map { CatalogIssue.missingCourseTitle($0.id) }
        let skillTexts = skills.filter(isMissingText).map { CatalogIssue.missingSkillText($0.id) }
        return courseTitles + skillTexts
    }

    private func isMissingText(_ skill: Skill) -> Bool {
        ([skill.name, skill.summary] + skill.levels.map(\.name)).contains(where: \.isMissingSourceText)
    }

    private func duplicates<ID: Comparable & Hashable>(in ids: [ID]) -> [ID] {
        Dictionary(grouping: ids) { $0 }.filter { $0.value.count > 1 }.keys.sorted()
    }

    private func firstPositions<ID: Hashable>(of ids: [ID]) -> [ID: Int] {
        Dictionary(ids.enumerated().map { ($1, $0) }) { first, _ in first }
    }
}
