import Testing

@testable import TomiCore

/// The experience answer from onboarding: "comfortable" hands the cook the first course as mastered.
/// The fixture menu has knife and eggs in the first course and roux, which needs knife, in the second.
@Suite struct ProgressExperienceTests {
    let comfortable = ProgressTestLog(experience: .comfortable)

    @Test func comfortableCountsEveryTechniqueOfTheFirstCourseAsMastered() {
        let progress = comfortable.progress([])
        #expect(progress.skill("knife")?.status == .mastered)
        #expect(progress.skill("eggs")?.status == .mastered)
        #expect(comfortable.progress(of: "knife", after: []).levels.map(\.isComplete) == [true, true])
        #expect(comfortable.progress(of: "knife", after: []).currentLevel == 2)
    }

    @Test func comfortableUnlocksTheSecondCourse() {
        let roux = comfortable.progress(of: "roux", after: [])
        #expect(roux.status == .served)
        #expect(roux.missingPrerequisites.isEmpty)
        #expect(roux.levels.map(\.isOpen) == [true, false])
        #expect(roux.levels.map(\.isComplete) == [false, false])
        #expect(comfortable.progress([]).focus(preferring: nil) == "roux")
    }

    @Test func grantedLevelsCountNoCooksThatWereNeverCooked() {
        let knife = comfortable.progress(of: "knife", after: [])
        #expect(knife.levels.map(\.cooks) == [0, 0])
        #expect(knife.levels.map(\.isGranted) == [true, true])
        #expect(comfortable.progress(of: "roux", after: []).levels.map(\.isGranted) == [false, false])
    }

    @Test(arguments: [Experience.never, Experience.basics])
    func theOtherAnswersGrantNothing(experience: Experience) {
        let log = ProgressTestLog(experience: experience)
        let progress = log.progress([])
        #expect(progress.skills.map(\.status) == [.served, .served, .locked(missing: ["knife"])])
        #expect(progress.skills.allSatisfy { $0.levels.allSatisfy { !$0.isGranted } })
        #expect(experience.grantedSkills(in: log.catalog).isEmpty)
    }

    @Test func realCooksCountOnTopOfGrantedSkills() {
        let entries = comfortable.cooks(1, of: "knife") + comfortable.cooks(2, of: "roux")
        let progress = comfortable.progress(entries)
        #expect(progress.skill("knife")?.levels.map(\.cooks) == [1, 0])
        #expect(progress.skill("knife")?.status == .mastered)
        #expect(progress.skill("roux")?.levels.map(\.isComplete) == [true, false])
        #expect(progress.skill("roux")?.currentLevel == 2)
    }

    @Test func aGrantedMenuIsFullyMasteredOnceTheRestIsCooked() {
        let entries = comfortable.cooks(2, of: "roux", level: 1) + comfortable.cooks(2, of: "roux", level: 2)
        let progress = comfortable.progress(entries)
        #expect(progress.skills.map(\.status) == [.mastered, .mastered, .mastered])
        #expect(progress.focus(preferring: nil) == nil)
    }

    @Test func theFirstCourseIsReadFromTheCatalog() {
        let saucesFirst = SkillCatalog.fixture(courses: [.fixture("sauces"), .fixture("basics")])
        let log = ProgressTestLog(catalog: saucesFirst, experience: .comfortable)
        #expect(Experience.comfortable.grantedSkills(in: saucesFirst) == ["roux"])
        #expect(log.progress([]).skills.map(\.status) == [.served, .served, .mastered])
    }

    @Test func aMenuWithoutCoursesGrantsNothing() {
        let empty = SkillCatalog.fixture(courses: [], skills: [])
        #expect(Experience.comfortable.grantedSkills(in: empty).isEmpty)
        #expect(ProgressTestLog(catalog: empty, experience: .comfortable).progress([]).skills.isEmpty)
    }
}
