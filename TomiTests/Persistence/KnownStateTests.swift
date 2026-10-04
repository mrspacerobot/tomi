import Foundation
import Testing
import TomiCore

@testable import Tomi

/// The state UI tests start from, worked out from the shipped menu.
@MainActor
@Suite struct KnownStateTests {
    let catalog: SkillCatalog
    let known: KnownState

    init() throws {
        catalog = try #require(BundledLibrary.catalog())
        known = KnownState(catalog: catalog)
    }

    @Test func theCookMasteredTheFirstCourseByExperienceAndOneMoreTechniqueByCooking() throws {
        let firstCourse = try #require(catalog.courses.first)
        let rules = ProgressRules(catalog: catalog, experience: known.profile.preferences.experience)
        let mastered = rules.progress(for: known.cookLog).masteredCount
        #expect(mastered == catalog.skills(in: firstCourse.id).count + 1)
        #expect(ProgressRules(catalog: catalog, experience: .basics).progress(for: known.cookLog).masteredCount == 1)
    }

    @Test func everyCookEarnedTheFullXP() {
        let cooks = known.cookLog.count
        #expect(cooks > 0)
        #expect(known.cookLog.earnedXP == cooks * GameRules.xpForFinishedCook(quizCorrect: true))
    }

    @Test func theCooksAreOnFixedDaysOneADay() {
        let dates = known.cookLog.map(\.session.date)
        #expect(dates.first == .october(5))
        #expect(Set(dates).count == dates.count)
        #expect(dates == dates.sorted())
    }

    @Test func itIsWrittenThroughTheProtocolIntoAnyStore() throws {
        let store = InMemoryProgressStore()
        try known.write(to: store)
        #expect(try store.profile() == known.profile)
        #expect(try store.cookLog().count == known.cookLog.count)
    }
}
