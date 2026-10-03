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

    @Test func levelsAreNumberedFromOneWithoutGaps() {
        let catalog = SkillCatalog.fixture(skills: [knife, eggs.with(levels: [.fixture(1), .fixture(3)]), roux])
        #expect(catalog.issues == [.levelsOutOfOrder("eggs")])
    }

    @Test func everyCourseHasAnEnglishTitle() {
        let catalog = SkillCatalog.fixture(courses: [.fixture("basics", title: " "), .fixture("sauces")])
        #expect(catalog.issues == [.missingCourseTitle("basics")])
    }

    @Test func everySkillHasEnglishText() {
        let catalog = SkillCatalog.fixture(skills: [knife, eggs.with(name: LocalizedText(["fr": "Oeufs"])), roux])
        #expect(catalog.issues == [.missingSkillText("eggs")])
    }

    @Test func everyLevelHasAnEnglishName() {
        let catalog = SkillCatalog.fixture(skills: [knife, eggs.with(levels: [.fixture(1, name: "")]), roux])
        #expect(catalog.issues == [.missingSkillText("eggs")])
    }

    @Test func skillsAreFoundByIDAndByCourse() {
        let catalog = SkillCatalog.fixture()
        #expect(catalog.skill("roux")?.course == "sauces")
        #expect(catalog.skill("stock") == nil)
        #expect(catalog.skills(in: "basics").map(\.id) == ["knife", "eggs"])
    }
}
