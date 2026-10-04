import Testing

@testable import TomiCore

@Suite struct ProgressMasteredCountTests {
    @Test func nothingIsMasteredBeforeTheFirstCook() {
        #expect(ProgressTestLog().progress([]).masteredCount == 0)
    }

    @Test func aSkillCountsOnceEveryLevelIsComplete() {
        let log = ProgressTestLog()
        let firstLevel = log.cooks(2, of: "knife", level: 1)
        #expect(log.progress(firstLevel).masteredCount == 0)
        #expect(log.progress(firstLevel + log.cooks(2, of: "knife", level: 2)).masteredCount == 1)
    }

    @Test func skillsGrantedByExperienceCountWithTheCookedOnes() {
        let log = ProgressTestLog(experience: .comfortable)
        #expect(log.progress([]).masteredCount == 2)
        let roux = log.cooks(2, of: "roux", level: 1) + log.cooks(2, of: "roux", level: 2)
        #expect(log.progress(roux).masteredCount == 3)
    }
}
