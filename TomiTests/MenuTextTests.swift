import Foundation
import Testing
import TomiCore

@testable import Tomi

@Suite struct MenuTextTests {
    @Test func everyCourseHasATitle() {
        for course in Course.allCases {
            #expect(!String(localized: course.title).isEmpty)
        }
    }

    @Test func everyTechniqueHasADistinctNameAndASummary() {
        let names = SkillID.allCases.map { String(localized: $0.name) }
        #expect(Set(names).count == SkillID.allCases.count)
        for id in SkillID.allCases {
            #expect(!String(localized: id.summary).isEmpty)
        }
    }
}
