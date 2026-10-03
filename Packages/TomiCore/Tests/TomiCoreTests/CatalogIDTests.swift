import Testing

@testable import TomiCore

@Suite struct CatalogIDTests {
    let knife = Skill.fixture("knife", in: "basics")
    let eggs = Skill.fixture("eggs", in: "basics")
    let roux = Skill.fixture("roux", in: "sauces", needs: ["knife"])

    @Test(arguments: ["", "  "])
    func aSkillIDIsNeverBlank(id: String) {
        let blank = Skill.fixture(SkillID(rawValue: id), in: "basics")
        let catalog = SkillCatalog.fixture(skills: [knife, blank, eggs, roux])
        #expect(catalog.issues == [.blankSkillID(position: 1)])
    }

    @Test(arguments: ["", "  "])
    func aCourseIDIsNeverBlank(id: String) {
        let blank = CourseID(rawValue: id)
        let courses: [Course] = [.fixture("basics"), .fixture(blank), .fixture("sauces")]
        let catalog = SkillCatalog.fixture(courses: courses, skills: [knife, eggs, .fixture("stray", in: blank), roux])
        #expect(catalog.issues == [.blankCourseID(position: 1)])
    }
}
