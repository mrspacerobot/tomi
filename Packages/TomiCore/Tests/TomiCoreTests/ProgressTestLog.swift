@testable import TomiCore

/// Builds cook logs and reads progress for the progress tests.
/// The menu is the fixture catalog unless a test brings its own: knife and eggs first, roux needing knife,
/// two levels each.
struct ProgressTestLog {
    let catalog: SkillCatalog

    init(catalog: SkillCatalog = .fixture()) {
        self.catalog = catalog
    }

    /// As many separate finished cooks of one skill at one level as asked for.
    func cooks(_ count: Int, of skill: SkillID, level: Int = 1) -> [CookEntry] {
        var entries: [CookEntry] = []
        for _ in 0..<count {
            entries.append(.fixture(skill, level: level))
        }
        return entries
    }

    /// Enough finished cooks to complete every level of every skill on the menu.
    func cooksCompletingEverything() -> [CookEntry] {
        var entries: [CookEntry] = []
        for skill in catalog.skills {
            for level in skill.levels {
                entries += cooks(GameRules.cooksToCompleteLevel, of: skill.id, level: level.number)
            }
        }
        return entries
    }

    func progress(_ entries: [CookEntry]) -> CookProgress {
        ProgressRules(catalog: catalog).progress(for: entries)
    }

    func progress(of skill: SkillID, after entries: [CookEntry]) -> SkillProgress {
        progress(entries).skill(skill)!
    }
}
