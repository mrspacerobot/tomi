import TomiCore

extension HomeMenuProgressTests {
    func options(catalog: SkillCatalog) -> [OptionCourse] {
        catalog.courses.map { courseOption($0, catalog: catalog) }
    }

    func courseOption(_ course: Course, catalog: SkillCatalog) -> OptionCourse {
        var option = OptionCourse(id: course.id, title: "Course \(course.id.rawValue)")
        option.skills = catalog.skills(in: course.id).map(option(for:))
        return option
    }

    func option(for skill: Skill) -> OptionSkill {
        var option = OptionSkill(id: skill.id, name: skill.name.resolved(preferredLanguages: ["en"]))
        option.levels = skill.levels.map { NamedLevel(number: $0.number, name: "Level \($0.number)") }
        option.prerequisites = skill.prerequisites
        return option
    }
}
