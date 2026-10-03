@testable import TomiCore

extension SkillCatalog {
    /// Knife and eggs first, roux needing knife.
    static let fixtureSkills: [Skill] = [
        .fixture("knife", in: "basics"),
        .fixture("eggs", in: "basics"),
        .fixture("roux", in: "sauces", needs: ["knife"]),
    ]

    /// A valid catalog of two courses. Each test breaks it in one way.
    static func fixture(courses: [Course]? = nil, skills: [Skill]? = nil) -> SkillCatalog {
        SkillCatalog(
            schemaVersion: SkillCatalog.supportedSchemaVersion,
            libraryVersion: 1,
            courses: courses ?? [.fixture("basics"), .fixture("sauces")],
            skills: skills ?? fixtureSkills
        )
    }
}
