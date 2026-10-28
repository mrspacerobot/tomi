import Testing

@testable import TomiCore

/// The menu in the server's order, each technique joined by its id to the server's snapshot. Nothing missing is
/// ever read as locked or as zero mastered.
@Suite struct HomeMenuProgressTests {
    @Test func followsServerOrderAndJoinsTheSnapshotByID() {
        let options = menuOptions().reversed().map { $0 }
        let menu = HomeMenuProgress.make(options: options, skills: snapshotSkills())

        #expect(menu.courses.map(\.id) == ["sauces", "basics"])
        #expect(menu.courses[1].skills.map(\.id) == ["knife", "eggs"])
        #expect(menu.courses[1].skills[1].progress?.status == .mastered)
        #expect(menu.courses[1].skills[0].progress?.currentLevel == 1)
    }

    @Test func aCourseCountsTheSkillsTheServerCallsMastered() {
        let menu = HomeMenuProgress.make(options: menuOptions(), skills: snapshotSkills())
        #expect(menu.courses[0].masteredCount == 1)
        #expect(menu.courses[0].skillCount == 2)
        #expect(menu.courses[1].masteredCount == 0)
    }

    @Test func aSkillTheSnapshotDoesNotNameStaysUnknown() {
        let skills = snapshotSkills().filter { $0.skill != "eggs" }
        let menu = HomeMenuProgress.make(options: menuOptions(), skills: skills)
        #expect(menu.courses[0].skills[1].progress == nil)
        #expect(menu.courses[0].masteredCount == nil)
    }

    @Test func withoutASnapshotNothingReadsAsLockedOrZeroMastered() {
        let menu = HomeMenuProgress.make(options: menuOptions(), skills: nil)
        #expect(menu.courses.flatMap(\.skills).allSatisfy { $0.progress == nil })
        #expect(menu.courses.allSatisfy { $0.masteredCount == nil })
    }

    @Test func aLockedSkillNamesItsMissingPrerequisitesAsTheServerNamesThem() {
        let menu = HomeMenuProgress.make(options: menuOptions(), skills: snapshotSkills())
        #expect(menu.courses[1].skills[0].progress?.status == .locked)
        #expect(menu.courses[1].skills[0].missingPrerequisiteNames == ["Knife work"])
    }

    @Test func aPrerequisiteTheMenuDoesNotNameLeavesTheNamesUnknown() {
        var skills = snapshotSkills()
        skills[2] = skill("roux", status: .locked, missing: ["stocks"])
        let menu = HomeMenuProgress.make(options: menuOptions(), skills: skills)
        #expect(menu.courses[1].skills[0].missingPrerequisiteNames == nil)
    }

    @Test func theCurrentLevelIsTheOneTheServerNamed() {
        let level = skill("knife", status: .served, missing: []).levelInProgress
        #expect(level?.number == 1)
        #expect(level?.cooksToComplete == 3)
    }
}
