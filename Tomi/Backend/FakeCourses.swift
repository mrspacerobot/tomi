import Foundation
import TomiCore

/// The menu of the fake server's options, from the bundled catalog in the cook's language.
nonisolated struct FakeCourses {
    let catalog: SkillCatalog?

    var courses: [OptionCourse] {
        guard let catalog else {
            return []
        }
        return catalog.courses.map { course(of: $0, in: catalog) }
    }

    private func course(of course: Course, in catalog: SkillCatalog) -> OptionCourse {
        var named = OptionCourse(id: course.id, title: text(course.title))
        named.skills = catalog.skills(in: course.id).map { skill(of: $0) }
        return named
    }

    private func skill(of skill: Skill) -> OptionSkill {
        var named = OptionSkill(id: skill.id, name: text(skill.name))
        named.summary = text(skill.summary)
        named.prerequisites = skill.prerequisites
        named.levels = skill.levels.map { NamedLevel(number: $0.number, name: text($0.name)) }
        return named
    }

    private func text(_ text: LocalizedText) -> String {
        LessonText.resolved(text)
    }
}
