@testable import TomiCore

extension Lesson {
    /// Garlic cooked in butter, taught at level 1 of eggs.
    static let fixtureLesson = Lesson(
        schemaVersion: Lesson.supportedSchemaVersion,
        id: "garlic-butter",
        revision: 1,
        skill: "eggs",
        level: 1,
        cuisine: "french",
        title: LocalizedText(["en": "A dish"]),
        minutes: 20,
        whyThis: LocalizedText(["en": "Why tonight"]),
        concept: LocalizedText(["en": "What it teaches"]),
        ingredients: [.fixture("garlic"), .fixture("butter")],
        equipment: ["stovetop"],
        steps: [.fixture(scene: .stir), .fixture(scene: .plate)],
        quiz: .fixture(),
        swaps: []
    )

    /// A valid lesson for `SkillCatalog.fixture()` and `IngredientTable.fixture()`. Each test breaks it in one way.
    static func fixture() -> Lesson {
        fixtureLesson
    }

    /// Every problem of this lesson when checked against the fixture catalog and the fixture table.
    func issuesInTheFixtureLibrary() -> [LessonIssue] {
        issues(catalog: .fixture(), table: .fixture())
    }
}
