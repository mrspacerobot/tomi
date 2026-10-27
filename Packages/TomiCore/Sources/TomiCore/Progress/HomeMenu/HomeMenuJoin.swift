/// Joins the server's names to the server's progress by skill id. A technique the snapshot does not name, or a
/// missing prerequisite the menu does not name, stays unknown: it is never read as locked or as zero.
struct HomeMenuJoin {
    let names: [SkillID: String]
    let skills: [SkillID: SnapshotSkill]?

    init(options: [OptionCourse], skills: [SnapshotSkill]?) {
        let listed = options.flatMap(\.skills).map { ($0.id, $0.name) }
        names = Dictionary(listed, uniquingKeysWith: { first, _ in first })
        self.skills = Self.byID(skills)
    }

    private static func byID(_ skills: [SnapshotSkill]?) -> [SkillID: SnapshotSkill]? {
        guard let skills else {
            return nil
        }
        let pairs = skills.map { ($0.skill, $0) }
        return Dictionary(pairs, uniquingKeysWith: { first, _ in first })
    }

    func course(_ option: OptionCourse) -> HomeCourseProgress {
        HomeCourseProgress(option: option, skills: option.skills.map(skill))
    }

    private func skill(_ option: OptionSkill) -> HomeSkillProgress {
        let progress = skills?[option.id]
        return HomeSkillProgress(option: option, progress: progress, missingPrerequisiteNames: missingNames(progress))
    }

    private func missingNames(_ progress: SnapshotSkill?) -> [String]? {
        guard let progress else {
            return []
        }
        let found = progress.missingPrerequisites.compactMap { names[$0] }
        guard found.count == progress.missingPrerequisites.count else {
            return nil
        }
        return found
    }
}
