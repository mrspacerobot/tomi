import Testing

@testable import TomiCore

@Suite struct SkillCatalogTests {
    @Test func everySkillIDIsInTheCatalogExactlyOnce() {
        #expect(SkillCatalog.all.map(\.id) == SkillID.allCases)
    }

    @Test func eachCourseHasThreeSkills() {
        for course in Course.allCases {
            #expect(SkillCatalog.skills(in: course).count == 3)
        }
    }

    @Test func foundationsNeedNothingFirst() {
        for skill in SkillCatalog.skills(in: .foundations) {
            #expect(skill.prerequisites.isEmpty)
        }
    }

    @Test func prerequisitesAlwaysComeFromAnEarlierPointOnTheMenu() {
        let order = Dictionary(uniqueKeysWithValues: SkillCatalog.all.enumerated().map { ($1.id, $0) })
        for skill in SkillCatalog.all {
            for prerequisite in skill.prerequisites {
                #expect(order[prerequisite]! < order[skill.id]!, "\(skill.id) needs \(prerequisite), which comes later")
            }
        }
    }
}
