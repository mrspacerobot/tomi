import Testing

@testable import TomiCore

/// Levels of one skill: counting cooks, completing a level, and which level the cook is on.
@Suite struct ProgressLevelTests {
    let log = ProgressTestLog()

    @Test func aLevelTakesTwoFinishedCooks() {
        #expect(GameRules.cooksToCompleteLevel == 2)
    }

    @Test func cooksAreCountedPerLevel() {
        let entries = log.cooks(2, of: "knife", level: 1) + log.cooks(1, of: "knife", level: 2)
        let knife = log.progress(of: "knife", after: entries)
        #expect(knife.levels.map(\.number) == [1, 2])
        #expect(knife.levels.map(\.cooks) == [2, 1])
    }

    @Test func aLevelIsNotCompleteOneCookShort() {
        let entries = log.cooks(GameRules.cooksToCompleteLevel - 1, of: "knife")
        let knife = log.progress(of: "knife", after: entries)
        #expect(knife.levels.map(\.isComplete) == [false, false])
        #expect(knife.currentLevel == 1)
    }

    @Test func completingALevelOpensTheNextOne() {
        let entries = log.cooks(GameRules.cooksToCompleteLevel, of: "knife")
        let knife = log.progress(of: "knife", after: entries)
        #expect(knife.levels.map(\.isComplete) == [true, false])
        #expect(knife.levels.map(\.isOpen) == [true, true])
        #expect(knife.currentLevel == 2)
    }

    @Test func theNextLevelStaysClosedUntilTheOneBeforeIsComplete() {
        let knife = log.progress(of: "knife", after: log.cooks(1, of: "knife"))
        #expect(knife.levels.map(\.isOpen) == [true, false])
    }

    @Test func extraCooksAtACompleteLevelDoNotSpillIntoTheNext() {
        let knife = log.progress(of: "knife", after: log.cooks(5, of: "knife", level: 1))
        #expect(knife.levels.map(\.cooks) == [5, 0])
        #expect(knife.currentLevel == 2)
    }

    @Test func noLevelOfALockedSkillIsOpen() {
        let roux = log.progress(of: "roux", after: [])
        #expect(roux.levels.map(\.isOpen) == [false, false])
        #expect(roux.currentLevel == 1)
    }

    @Test func aSkillWithOneLevelIsMasteredByCompletingIt() {
        let knife = Skill.fixture("knife", in: "basics").with(levels: [.fixture(1)])
        let log = ProgressTestLog(catalog: .fixture(courses: [.fixture("basics")], skills: [knife]))
        #expect(log.progress(of: "knife", after: log.cooks(1, of: "knife")).status == .served)
        let mastered = log.progress(of: "knife", after: log.cooks(2, of: "knife"))
        #expect(mastered.status == .mastered)
        #expect(mastered.currentLevel == 1)
    }

    @Test func aMasteredSkillStaysOnItsLastLevel() {
        let entries = log.cooks(2, of: "knife", level: 1) + log.cooks(2, of: "knife", level: 2)
        #expect(log.progress(of: "knife", after: entries).currentLevel == 2)
    }
}
