import Foundation
import Testing
import TomiCore

@testable import Tomi

/// The progress a screen shows is worked out from the saved profile and cook log every time it is read.
@MainActor
@Suite struct ProgressSummaryReaderTests {
    let store = InMemoryProgressStore()
    let catalog: SkillCatalog
    let calendar = Calendar(identifier: .gregorian)

    init() throws {
        catalog = try #require(BundledLibrary.catalog())
    }

    @Test func anEmptyStoreShowsNoProgress() throws {
        let summary = try reader().summary(at: .october(8))
        #expect(summary.game.xp == 0)
        #expect(summary.masteredCount == 0)
    }

    @Test func xpComesFromTheCookLog() throws {
        try store.add(.fixture("eggs", onOctober: 5))
        try store.add(.fixture("eggs", onOctober: 6))
        let summary = try reader().summary(at: .october(8))
        #expect(summary.game.xp == 2 * GameRules.xpForFinishedCook(quizCorrect: true))
    }

    @Test func theSummaryIsTheOneTomiCoreGivesForTheSavedState() throws {
        let known = KnownState(catalog: catalog)
        try known.write(to: store)
        let summary = try reader().summary(at: .october(8))
        let log = try store.cookLog()
        let goal = known.profile.preferences.weeklyGoal
        let rules = ProgressRules(catalog: catalog, experience: .comfortable)
        #expect(summary.game == GameStateRules(calendar: calendar).gameState(for: log, goal: goal, now: .october(8)))
        #expect(summary.masteredCount == rules.progress(for: log).masteredCount)
    }

    @Test func theSavedExperienceAnswerCountsTowardsMastery() throws {
        var profile = CookProfile()
        profile.preferences.experience = .comfortable
        try store.saveProfile(profile, at: .october(5))
        let firstCourse = try #require(catalog.courses.first)
        let granted = catalog.skills(in: firstCourse.id).count
        #expect(try reader().summary(at: .october(8)).masteredCount == granted)
    }

    @Test func withoutAMenuTheMasteredCountIsLeftOut() throws {
        let reader = ProgressSummaryReader(store: store, catalog: nil, calendar: calendar)
        #expect(try reader.summary(at: .october(8)).masteredCount == nil)
    }

    @Test func aStoreThatCannotBeReadGivesNoSummaryAtAll() {
        let reader = ProgressSummaryReader(store: UnavailableProgressStore(), catalog: catalog, calendar: calendar)
        #expect(throws: ProgressStoreError.unavailable) { try reader.summary(at: .october(8)) }
    }

    private func reader() -> ProgressSummaryReader {
        ProgressSummaryReader(store: store, catalog: catalog, calendar: calendar)
    }
}
