/// What an experience answer is worth on the menu.
extension Experience {
    /// Whether this answer hands the cook the first course of the menu as already mastered.
    /// "Never" and "basics" differ only in how much Tomi explains, so neither grants anything.
    public var grantsFirstCourse: Bool {
        switch self {
        case .never: false
        case .basics: false
        case .comfortable: true
        }
    }

    /// The skills that count as mastered without having been cooked: every skill of the first course
    /// in the catalog, or none. The course is read from the catalog, so this holds for any menu.
    public func grantedSkills(in catalog: SkillCatalog) -> Set<SkillID> {
        guard grantsFirstCourse, let firstCourse = catalog.courses.first else {
            return []
        }
        var granted: Set<SkillID> = []
        for skill in catalog.skills(in: firstCourse.id) {
            granted.insert(skill.id)
        }
        return granted
    }
}
