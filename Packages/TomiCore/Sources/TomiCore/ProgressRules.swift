/// Works out the cook's progress from the cook log: cooks per level, open levels, and served and mastered skills.
/// The catalog is a parameter, so the rules hold for any menu and never name a skill.
public struct ProgressRules: Sendable {
    public let catalog: SkillCatalog

    public init(catalog: SkillCatalog) {
        self.catalog = catalog
    }

    /// Progress for every skill on the menu. Entries may come in any order and may repeat.
    /// Entries for a skill or level the catalog does not know are left out,
    /// because an older app may read a log written by a newer one.
    /// An entry for a lesson the library does not know still counts at its skill and level:
    /// a newer library may add lessons to a level this app already has, and the cook did cook it.
    public func progress(for entries: [CookEntry]) -> CookProgress {
        let counts = CookCounts(entries: entries)
        var skills: [SkillProgress] = []
        for skill in catalog.skills {
            skills.append(progress(of: skill, counts: counts))
        }
        return CookProgress(skills: skills)
    }

    private func progress(of skill: Skill, counts: CookCounts) -> SkillProgress {
        let missing = missingPrerequisites(of: skill, counts: counts)
        let levels = levels(of: skill, counts: counts, isServed: missing.isEmpty)
        return SkillProgress(skill: skill.id, levels: levels, missingPrerequisites: missing)
    }

    /// Level 1 is open once the skill is served. Each later level opens when every level before it is complete.
    private func levels(of skill: Skill, counts: CookCounts, isServed: Bool) -> [LevelProgress] {
        var levels: [LevelProgress] = []
        var isOpen = isServed
        for level in skill.levels {
            let cooks = counts.cooks(of: skill.id, level: level.number)
            levels.append(LevelProgress(number: level.number, cooks: cooks, isOpen: isOpen))
            isOpen = isOpen && GameRules.isLevelComplete(cooks: cooks)
        }
        return levels
    }

    /// A skill is served when the first level of every prerequisite is complete.
    /// Asking for every level would hold the next techniques back for weeks.
    private func missingPrerequisites(of skill: Skill, counts: CookCounts) -> [SkillID] {
        var missing: [SkillID] = []
        for prerequisite in skill.prerequisites where !isFirstLevelComplete(of: prerequisite, counts: counts) {
            missing.append(prerequisite)
        }
        return missing
    }

    private func isFirstLevelComplete(of id: SkillID, counts: CookCounts) -> Bool {
        guard let skill = catalog.skill(id) else {
            return false
        }
        guard let firstLevel = skill.levels.first else {
            return false
        }
        return GameRules.isLevelComplete(cooks: counts.cooks(of: id, level: firstLevel.number))
    }
}
