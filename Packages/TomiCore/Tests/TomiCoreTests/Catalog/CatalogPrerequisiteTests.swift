import Testing

@testable import TomiCore

@Suite struct CatalogPrerequisiteTests {
    let knife = Skill.fixture("knife", in: "basics")
    let eggs = Skill.fixture("eggs", in: "basics")
    let roux = Skill.fixture("roux", in: "sauces", needs: ["knife"])

    @Test func aPrerequisiteMustExist() {
        let roux = Skill.fixture("roux", in: "sauces", needs: ["stock"])
        #expect(SkillCatalog.fixture(skills: [knife, eggs, roux]).issues == [.unknownPrerequisite("roux", "stock")])
    }

    @Test func aPrerequisiteMustComeEarlierOnTheMenu() {
        let knife = Skill.fixture("knife", in: "basics", needs: ["eggs"])
        #expect(SkillCatalog.fixture(skills: [knife, eggs, roux]).issues == [.prerequisiteNotEarlier("knife", "eggs")])
    }

    @Test func aSkillCannotNeedItself() {
        let eggs = Skill.fixture("eggs", in: "basics", needs: ["eggs"])
        #expect(SkillCatalog.fixture(skills: [knife, eggs, roux]).issues == [.prerequisiteNotEarlier("eggs", "eggs")])
    }

    @Test func aPrerequisiteMayComeEarlierInTheSameCourse() {
        let eggs = Skill.fixture("eggs", in: "basics", needs: ["knife"])
        #expect(SkillCatalog.fixture(skills: [knife, eggs, roux]).issues.isEmpty)
    }

    @Test func everyMissingPrerequisiteIsReported() {
        let roux = Skill.fixture("roux", in: "sauces", needs: ["stock", "knife", "butter"])
        #expect(
            SkillCatalog.fixture(skills: [knife, eggs, roux]).issues
                == [.unknownPrerequisite("roux", "stock"), .unknownPrerequisite("roux", "butter")]
        )
    }
}
