/// Joins server names to local status only after checking the matching course, levels and prerequisites.
struct HomeMenuCompatibility {
    let options: [CourseID: OptionCourse]
    let catalog: SkillCatalog?
    let progress: CookProgress?

    init(options: [OptionCourse], catalog: SkillCatalog?, progress: CookProgress?) {
        self.options = Dictionary(options.map { ($0.id, $0) }, uniquingKeysWith: { first, _ in first })
        self.catalog = catalog
        self.progress = progress
    }

    func course(_ option: OptionCourse) -> HomeCourseProgress {
        let skills = option.skills.map { skill($0, in: option) }
        return HomeCourseProgress(option: option, skills: skills)
    }

    private func skill(_ option: OptionSkill, in course: OptionCourse) -> HomeSkillProgress {
        let matched = matchedProgress(option, course: course)
        return HomeSkillProgress(
            option: option,
            progress: matched,
            missingPrerequisiteNames: prerequisiteNames(for: matched)
        )
    }

    private func matchedProgress(_ option: OptionSkill, course: OptionCourse) -> SkillProgress? {
        guard catalog != nil, let progress, compatible(option, course: course, visited: []) else { return nil }
        guard let matched = progress.skill(option.id), prerequisiteNames(for: matched) != nil else { return nil }
        return matched
    }

    private func prerequisiteNames(for progress: SkillProgress?) -> [String]? {
        guard let progress, case .locked(let missing) = progress.status else { return [] }
        let names = missing.compactMap(name(of:))
        return names.count == missing.count ? names : nil
    }

    private func name(of id: SkillID) -> String? {
        options.values.compactMap { course in
            course.skills.first(where: { $0.id == id })?.name
        }.first
    }

    private func compatible(_ option: OptionSkill, course: OptionCourse, visited: Set<SkillID>) -> Bool {
        guard !visited.contains(option.id), let definition = catalog?.skill(option.id),
            definition.course == course.id, definition.levels.map(\.number) == option.levels.map(\.number),
            definition.prerequisites == option.prerequisites
        else {
            return false
        }
        return prerequisitesMatch(option, visited: visited.union([option.id]))
    }

    private func prerequisitesMatch(_ option: OptionSkill, visited: Set<SkillID>) -> Bool {
        option.prerequisites.allSatisfy { prerequisite in
            guard let course = options.values.first(where: { $0.skills.contains { $0.id == prerequisite } }),
                let skill = course.skills.first(where: { $0.id == prerequisite })
            else {
                return false
            }
            return compatible(skill, course: course, visited: visited)
        }
    }
}
