import Testing

@testable import TomiCore

@Suite struct CatalogValidationTests {
    let knife = Skill.fixture("knife", in: "basics")
    let eggs = Skill.fixture("eggs", in: "basics")
    let roux = Skill.fixture("roux", in: "sauces", needs: ["knife"])

    @Test func theFixtureIsValid() {
        #expect(SkillCatalog.fixture().issues.isEmpty)
    }

    @Test func aCatalogServesAtLeastOneCourse() {
        #expect(SkillCatalog.fixture(courses: [], skills: []).issues == [.noCourses])
    }

    @Test func aSkillIDMayAppearOnlyOnce() {
        let catalog = SkillCatalog.fixture(skills: [knife, eggs, eggs, roux])
        #expect(catalog.issues == [.duplicateSkill("eggs")])
    }

    @Test func aCourseIDMayAppearOnlyOnce() {
        let catalog = SkillCatalog.fixture(courses: [.fixture("basics"), .fixture("sauces"), .fixture("basics")])
        #expect(catalog.issues == [.duplicateCourse("basics")])
    }

    @Test func aSkillMustBelongToAKnownCourse() {
        let stray = Skill.fixture("stray", in: "desserts")
        #expect(
            SkillCatalog.fixture(skills: [knife, eggs, roux, stray]).issues == [.unknownCourse("stray", "desserts")]
        )
    }

    @Test func aSkillInAnUnknownCourseDoesNotPutItsNeighboursOutOfOrder() {
        let stray = Skill.fixture("stray", in: "desserts")
        #expect(
            SkillCatalog.fixture(skills: [stray, knife, eggs, roux]).issues == [.unknownCourse("stray", "desserts")]
        )
    }

    @Test func everyCourseServesAtLeastOneSkill() {
        let catalog = SkillCatalog.fixture(courses: [.fixture("basics"), .fixture("sauces"), .fixture("desserts")])
        #expect(catalog.issues == [.emptyCourse("desserts")])
    }

    @Test func skillsAreListedInCourseOrder() {
        let catalog = SkillCatalog.fixture(skills: [knife, roux, eggs])
        #expect(catalog.issues == [.skillOutOfCourseOrder("eggs")])
    }

    @Test func coursesAreServedInTheOrderTheyAreListed() {
        let catalog = SkillCatalog.fixture(skills: [Skill.fixture("roux", in: "sauces"), knife, eggs])
        #expect(catalog.issues == [.skillOutOfCourseOrder("knife")])
    }

    @Test func everyProblemIsReportedAtOnce() {
        let catalog = SkillCatalog.fixture(skills: [knife, eggs.with(levels: []), eggs, roux.with(name: .init([:]))])
        #expect(catalog.issues == [.duplicateSkill("eggs"), .noLevels("eggs"), .missingSkillText("roux")])
    }
}
