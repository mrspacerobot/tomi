import Testing

@testable import TomiCore

/// Which skills are locked, served or mastered.
@Suite struct ProgressUnlockTests {
    let log = ProgressTestLog()

    @Test func anEmptyLogServesOnlySkillsWithoutPrerequisites() {
        let progress = log.progress([])
        #expect(progress.skills.map(\.skill) == ["knife", "eggs", "roux"])
        #expect(progress.skills.map(\.status) == [.served, .served, .locked(missing: ["knife"])])
        #expect(progress.skills.allSatisfy { $0.levels.map(\.cooks) == [0, 0] })
    }

    @Test func aSkillIsServedOnceLevelOneOfItsPrerequisiteIsComplete() {
        let roux = log.progress(of: "roux", after: log.cooks(2, of: "knife", level: 1))
        #expect(roux.status == .served)
        #expect(roux.missingPrerequisites.isEmpty)
        #expect(roux.levels.map(\.isOpen) == [true, false])
    }

    @Test func oneCookOfAPrerequisiteIsNotEnough() {
        let roux = log.progress(of: "roux", after: log.cooks(1, of: "knife", level: 1))
        #expect(roux.status == .locked(missing: ["knife"]))
    }

    @Test func aLaterLevelOfAPrerequisiteDoesNotStandInForLevelOne() {
        let roux = log.progress(of: "roux", after: log.cooks(2, of: "knife", level: 2))
        #expect(roux.status == .locked(missing: ["knife"]))
    }

    @Test func aLockedSkillNamesOnlyThePrerequisitesStillMissing() {
        let roux = Skill.fixture("roux", in: "sauces", needs: ["knife", "eggs"])
        let skills: [Skill] = [.fixture("knife", in: "basics"), .fixture("eggs", in: "basics"), roux]
        let log = ProgressTestLog(catalog: .fixture(skills: skills))
        #expect(log.progress(of: "roux", after: []).status == .locked(missing: ["knife", "eggs"]))
        #expect(log.progress(of: "roux", after: log.cooks(2, of: "knife")).status == .locked(missing: ["eggs"]))
        let both = log.cooks(2, of: "knife") + log.cooks(2, of: "eggs")
        #expect(log.progress(of: "roux", after: both).status == .served)
    }

    @Test func aSkillIsMasteredWhenAllItsLevelsAreComplete() {
        let levelOne = log.cooks(2, of: "knife", level: 1)
        #expect(log.progress(of: "knife", after: levelOne).status == .served)
        let knife = log.progress(of: "knife", after: levelOne + log.cooks(2, of: "knife", level: 2))
        #expect(knife.status == .mastered)
        #expect(knife.isMastered)
        #expect(knife.isServed)
    }

    @Test func theWholeMenuIsMasteredWhenEveryLevelOfEverySkillIsComplete() {
        let progress = log.progress(log.cooksCompletingEverything())
        #expect(progress.skills.map(\.status) == [.mastered, .mastered, .mastered])
        #expect(progress.skills.allSatisfy { $0.levels.allSatisfy(\.isComplete) })
    }
}
