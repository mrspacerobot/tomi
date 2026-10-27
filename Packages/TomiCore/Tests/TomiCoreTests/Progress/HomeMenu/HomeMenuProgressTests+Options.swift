@testable import TomiCore

/// A small menu as `GET /v1/options` sends it, and the snapshot's skills for it.
extension HomeMenuProgressTests {
    func menuOptions() -> [OptionCourse] {
        [
            course("basics", skills: [option("knife", name: "Knife work"), option("eggs", name: "Eggs")]),
            course("sauces", skills: [option("roux", name: "Roux")]),
        ]
    }

    func snapshotSkills() -> [SnapshotSkill] {
        [
            skill("knife", status: .served, missing: []),
            skill("eggs", status: .mastered, missing: []),
            skill("roux", status: .locked, missing: ["knife"]),
        ]
    }

    func skill(_ id: SkillID, status: SnapshotSkillStatus, missing: [SkillID]) -> SnapshotSkill {
        let level = SnapshotLevel(number: 1, cooks: 1, cooksToComplete: 3, open: true, granted: false, complete: false)
        return SnapshotSkill(skill: id, status: status, missingPrerequisites: missing, currentLevel: 1, levels: [level])
    }

    private func course(_ id: CourseID, skills: [OptionSkill]) -> OptionCourse {
        var course = OptionCourse(id: id, title: "Course \(id.rawValue)")
        course.skills = skills
        return course
    }

    private func option(_ id: SkillID, name: String) -> OptionSkill {
        OptionSkill(id: id, name: name)
    }
}
