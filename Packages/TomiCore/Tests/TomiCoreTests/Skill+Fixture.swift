@testable import TomiCore

extension Skill {
    static func fixture(_ id: SkillID, in course: CourseID, needs prerequisites: [SkillID] = []) -> Skill {
        Skill(
            id: id,
            course: course,
            name: LocalizedText(["en": "Skill \(id.rawValue)"]),
            summary: LocalizedText(["en": "What it teaches"]),
            prerequisites: prerequisites,
            levels: [.fixture(1), .fixture(2)]
        )
    }

    func with(levels: [SkillLevel]) -> Skill {
        Skill(id: id, course: course, name: name, summary: summary, prerequisites: prerequisites, levels: levels)
    }

    func with(name: LocalizedText) -> Skill {
        Skill(id: id, course: course, name: name, summary: summary, prerequisites: prerequisites, levels: levels)
    }
}
