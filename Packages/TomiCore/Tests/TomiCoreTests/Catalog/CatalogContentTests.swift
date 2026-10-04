import Testing

@testable import TomiCore

@Suite struct CatalogContentTests {
    let knife = Skill.fixture("knife", in: "basics")
    let eggs = Skill.fixture("eggs", in: "basics")
    let roux = Skill.fixture("roux", in: "sauces", needs: ["knife"])

    @Test func everySkillHasAtLeastOneLevel() {
        let catalog = SkillCatalog.fixture(skills: [knife, eggs.with(levels: []), roux])
        #expect(catalog.issues == [.noLevels("eggs")])
    }

    @Test func aSingleLevelIsEnough() {
        #expect(SkillCatalog.fixture(skills: [knife, eggs.with(levels: [.fixture(1)]), roux]).issues.isEmpty)
    }

    /// A gap, a level 0, a repeated number and a reversed order.
    @Test(arguments: [[1, 3], [0, 1], [1, 1], [2, 1]])
    func levelsAreNumberedFromOneWithoutGaps(numbers: [Int]) {
        let catalog = SkillCatalog.fixture(skills: [knife, eggs.with(levels: numbers.map { .fixture($0) }), roux])
        #expect(catalog.issues == [.levelsOutOfOrder("eggs")])
    }

    @Test(arguments: [LocalizedText(["en": " "]), LocalizedText(["fr": "Les bases"])])
    func everyCourseHasAnEnglishTitle(title: LocalizedText) {
        let catalog = SkillCatalog.fixture(courses: [Course(id: "basics", title: title), .fixture("sauces")])
        #expect(catalog.issues == [.missingCourseTitle("basics")])
    }

    @Test func everySkillHasAnEnglishName() {
        let catalog = SkillCatalog.fixture(skills: [knife, eggs.with(name: LocalizedText(["fr": "Oeufs"])), roux])
        #expect(catalog.issues == [.missingSkillText("eggs")])
    }

    @Test func everySkillHasAnEnglishSummary() {
        let catalog = SkillCatalog.fixture(skills: [knife, eggs.with(summary: LocalizedText(["en": ""])), roux])
        #expect(catalog.issues == [.missingSkillText("eggs")])
    }

    @Test func everyLevelHasAnEnglishName() {
        let levels: [SkillLevel] = [.fixture(1), .fixture(2, name: "")]
        let catalog = SkillCatalog.fixture(skills: [knife, eggs.with(levels: levels), roux])
        #expect(catalog.issues == [.missingSkillText("eggs")])
    }

    @Test func skillsAreFoundByIDAndByCourse() {
        let catalog = SkillCatalog.fixture()
        #expect(catalog.skill("roux")?.course == "sauces")
        #expect(catalog.skill("stock") == nil)
        #expect(catalog.skills(in: "basics").map(\.id) == ["knife", "eggs"])
        #expect(catalog.skills(in: "desserts").isEmpty)
    }
}
