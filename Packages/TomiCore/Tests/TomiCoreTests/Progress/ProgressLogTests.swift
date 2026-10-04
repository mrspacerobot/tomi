import Testing

@testable import TomiCore

/// What the rules make of an imperfect log: abandoned cooks, entries from a newer menu, copies and odd orders.
@Suite struct ProgressLogTests {
    let log = ProgressTestLog()

    @Test func cooksStoppedEarlyDoNotCount() {
        let finished = CookEntry.fixture("knife")
        let stopped = CookEntry.fixture("knife").stoppedBeforeTheEnd()
        let knife = log.progress(of: "knife", after: [finished, stopped])
        #expect(knife.levels.map(\.cooks) == [1, 0])
        #expect(knife.levels.map(\.isComplete) == [false, false])
    }

    @Test func entriesForASkillTheCatalogDoesNotKnowAreIgnored() {
        let entries = log.cooks(2, of: "sous-vide") + log.cooks(1, of: "knife")
        #expect(log.progress(entries) == log.progress(log.cooks(1, of: "knife")))
    }

    @Test func entriesForALevelTheCatalogDoesNotKnowAreIgnored() {
        let entries = log.cooks(2, of: "knife", level: 3) + log.cooks(2, of: "knife", level: 0)
        let knife = log.progress(of: "knife", after: entries)
        #expect(knife.levels.map(\.cooks) == [0, 0])
        #expect(knife.status == .served)
    }

    /// A newer library may add lessons to a level this app knows. The entry records its own skill and level.
    @Test func cooksOfLessonsTheLibraryDoesNotKnowCountAtTheirSkillAndLevel() {
        let fromNewerLibrary = CookEntry.fixture("knife").with(lesson: "knife-julienne-from-a-newer-library")
        let anotherOne = CookEntry.fixture("knife").with(lesson: "knife-brunoise-from-a-newer-library")
        let knife = log.progress(of: "knife", after: [fromNewerLibrary, anotherOne])
        #expect(knife.levels.map(\.cooks) == [2, 0])
        #expect(knife.currentLevel == 2)
    }

    @Test func theSameEntryTwiceCountsOnce() {
        let cook = CookEntry.fixture("knife")
        let knife = log.progress(of: "knife", after: [cook, cook])
        #expect(knife.levels.map(\.cooks) == [1, 0])
    }

    @Test func mergingTwoOverlappingLogsEqualsOneLog() {
        let shared = log.cooks(1, of: "knife")
        let onlyOnPhone = log.cooks(1, of: "knife") + log.cooks(1, of: "eggs")
        let onlyOnTablet = log.cooks(2, of: "roux")
        let phone = shared + onlyOnPhone
        let tablet = shared + onlyOnTablet
        let oneLog = shared + onlyOnPhone + onlyOnTablet
        #expect(log.progress(phone + tablet) == log.progress(oneLog))
        #expect(log.progress(tablet + phone) == log.progress(oneLog))
        #expect(log.progress(of: "knife", after: phone + tablet).levels.map(\.cooks) == [2, 0])
    }

    @Test func theOrderOfEntriesDoesNotMatter() {
        let entries = log.cooksCompletingEverything()
        #expect(log.progress(entries.reversed()) == log.progress(entries))
    }

    /// The chosen rule: every finished cook counts at its own level, whether or not that level was open.
    @Test func aCookAtALevelNotYetOpenStillCountsAtThatLevel() {
        let early = log.cooks(2, of: "knife", level: 2)
        let knife = log.progress(of: "knife", after: early)
        #expect(knife.levels.map(\.cooks) == [0, 2])
        #expect(knife.levels.map(\.isComplete) == [false, true])
        #expect(knife.levels.map(\.isOpen) == [true, false])
        #expect(knife.currentLevel == 1)
        #expect(knife.status == .served)
        #expect(log.progress(of: "knife", after: early + log.cooks(2, of: "knife", level: 1)).status == .mastered)
    }

    @Test func aCompleteLevelDoesNotOpenTheNextWhileAnEarlierOneIsIncomplete() {
        let knife = Skill.fixture("knife", in: "basics").with(levels: [.fixture(1), .fixture(2), .fixture(3)])
        let log = ProgressTestLog(catalog: .fixture(courses: [.fixture("basics")], skills: [knife]))
        let early = log.cooks(2, of: "knife", level: 2)
        #expect(log.progress(of: "knife", after: early).levels.map(\.isOpen) == [true, false, false])
        let caughtUp = early + log.cooks(2, of: "knife", level: 1)
        #expect(log.progress(of: "knife", after: caughtUp).levels.map(\.isOpen) == [true, true, true])
        #expect(log.progress(of: "knife", after: caughtUp).currentLevel == 3)
    }

    /// A newer catalog may add a prerequisite to a skill the cook has already finished.
    @Test func aSkillWithEveryLevelCompleteShowsAsMasteredEvenIfAPrerequisiteIsMissing() {
        let early = log.cooks(2, of: "roux", level: 1) + log.cooks(2, of: "roux", level: 2)
        let roux = log.progress(of: "roux", after: early)
        #expect(roux.status == .mastered)
        #expect(roux.missingPrerequisites == ["knife"])
        #expect(!roux.isServed)
    }

    @Test func cooksOfALockedSkillAreKeptForWhenItIsServed() {
        let early = log.cooks(2, of: "roux", level: 1)
        let locked = log.progress(of: "roux", after: early)
        #expect(locked.status == .locked(missing: ["knife"]))
        #expect(locked.levels.map(\.cooks) == [2, 0])
        let served = log.progress(of: "roux", after: early + log.cooks(2, of: "knife"))
        #expect(served.status == .served)
        #expect(served.currentLevel == 2)
    }
}
