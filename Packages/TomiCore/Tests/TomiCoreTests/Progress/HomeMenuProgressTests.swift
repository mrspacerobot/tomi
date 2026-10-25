import Testing

@testable import TomiCore

@Suite struct HomeMenuProgressTests {
    let catalog = SkillCatalog.fixture()

    @Test func followsServerOrderAndUsesCompatibleLocalProgress() {
        var serverOptions = options(catalog: catalog)
        serverOptions.reverse()
        serverOptions[0].skills.reverse()
        let progress = ProgressTestLog(catalog: catalog).progress([])

        let menu = HomeMenuProgress.make(options: serverOptions, catalog: catalog, progress: progress)

        #expect(menu.courses.map(\.id) == serverOptions.map(\.id))
        #expect(menu.courses[0].title == serverOptions[0].title)
        #expect(menu.courses[0].skills.map(\.id) == serverOptions[0].skills.map(\.id))
        #expect(menu.courses.flatMap(\.skills).allSatisfy { $0.progress != nil })
    }

    @Test func experienceGrantsAppearWithoutInventingCooks() {
        let progress = ProgressTestLog(catalog: catalog, experience: .comfortable).progress([])
        let menu = HomeMenuProgress.make(options: options(catalog: catalog), catalog: catalog, progress: progress)
        #expect(menu.courses[0].masteredCount == menu.courses[0].skillCount)
        #expect(menu.courses[0].skills.allSatisfy { $0.progress?.isMastered == true })
    }

    @Test func masteryCountsFollowTheDeduplicatedCookLog() {
        let log = ProgressTestLog(catalog: catalog)
        let completed = log.cooksCompletingEverything()
        let progress = log.progress(completed + completed)
        let menu = HomeMenuProgress.make(options: options(catalog: catalog), catalog: catalog, progress: progress)
        #expect(menu.courses.allSatisfy { $0.masteredCount == $0.skillCount })
        #expect(menu.courses.flatMap(\.skills).allSatisfy { $0.progress?.isMastered == true })
    }

    @Test func aDifferentCourseForTheSameIDLeavesStatusUnknown() {
        var menuOptions = options(catalog: catalog)
        menuOptions[0].skills.removeAll { $0.id == "knife" }
        let knife = catalog.skills[0]
        menuOptions[1].skills.append(option(for: knife))
        let progress = ProgressTestLog(catalog: catalog).progress([])

        let menu = HomeMenuProgress.make(options: menuOptions, catalog: catalog, progress: progress)

        #expect(menu.courses[1].skills.first(where: { $0.id == "knife" })?.progress == nil)
        #expect(menu.courses[1].masteredCount == nil)
    }

    @Test func differentLevelsLeaveStatusUnknown() {
        var menuOptions = options(catalog: catalog)
        menuOptions[0].skills[0].levels = [NamedLevel(number: 999, name: "Unknown")]
        let progress = ProgressTestLog(catalog: catalog).progress([])

        let menu = HomeMenuProgress.make(options: menuOptions, catalog: catalog, progress: progress)

        #expect(menu.courses[0].skills[0].progress == nil)
        #expect(menu.courses[0].masteredCount == nil)
    }

    @Test func changedPrerequisitesLeaveStatusUnknown() {
        var menuOptions = options(catalog: catalog)
        menuOptions[1].skills[0].prerequisites = []
        let progress = ProgressTestLog(catalog: catalog).progress([])

        let menu = HomeMenuProgress.make(options: menuOptions, catalog: catalog, progress: progress)

        #expect(menu.courses[1].skills[0].progress == nil)
    }

    @Test func incompatiblePrerequisiteHidesDependentProgress() {
        var menuOptions = options(catalog: catalog)
        menuOptions[0].skills[0].levels = [NamedLevel(number: 999, name: "Unknown")]
        let progress = ProgressTestLog(catalog: catalog).progress([])

        let menu = HomeMenuProgress.make(options: menuOptions, catalog: catalog, progress: progress)

        #expect(menu.courses[1].skills[0].progress == nil)
    }

    @Test func missingLocalProgressNeverReadsAsLockedOrZeroMastered() {
        let menu = HomeMenuProgress.make(options: options(catalog: catalog), catalog: catalog, progress: nil)

        #expect(menu.courses[0].skills.allSatisfy { $0.progress == nil })
        #expect(menu.courses[0].masteredCount == nil)
    }

    @Test func lockedStatusNamesItsServerListedPrerequisite() {
        let progress = ProgressTestLog(catalog: catalog).progress([])

        let menu = HomeMenuProgress.make(options: options(catalog: catalog), catalog: catalog, progress: progress)

        #expect(menu.courses[1].skills[0].missingPrerequisiteNames == ["Skill knife"])
    }

}
