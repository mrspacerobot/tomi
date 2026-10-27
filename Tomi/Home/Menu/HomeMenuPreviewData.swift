import Foundation
import TomiCore

/// Preview options use the reviewed bundled catalog rather than invented technique content.
enum HomeMenuPreviewData {
    static let catalog = BundledLibrary.catalog()
    static let options = options(catalog: catalog)
    static let menu = makeMenu()

    private static func makeMenu() -> HomeMenuProgress? {
        guard let catalog else { return nil }
        return HomeMenuProgress.make(
            options: options,
            catalog: catalog,
            progress: SavedProgressModel.previewWithProgress().summary?.skillProgress
        )
    }

    static func options(catalog: SkillCatalog?) -> [OptionCourse] {
        guard let catalog else { return [] }
        return catalog.courses.map { course in
            var option = OptionCourse(
                id: course.id,
                title: course.title.resolved(preferredLanguages: Locale.preferredLanguages)
            )
            option.skills = catalog.skills(in: course.id).map(skillOption)
            return option
        }
    }

    private static func skillOption(_ skill: TomiCore.Skill) -> OptionSkill {
        var option = OptionSkill(id: skill.id, name: skill.name.resolved(preferredLanguages: Locale.preferredLanguages))
        option.summary = skill.summary.resolved(preferredLanguages: Locale.preferredLanguages)
        option.prerequisites = skill.prerequisites
        option.levels = skill.levels.map {
            NamedLevel(number: $0.number, name: $0.name.resolved(preferredLanguages: Locale.preferredLanguages))
        }
        return option
    }
}
