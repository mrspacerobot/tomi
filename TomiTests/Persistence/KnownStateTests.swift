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

    /// The first technique after the first course, cooked twice at each level, and nothing else.
    @Test func theCookCookedTheFirstTechniqueAfterTheFirstCourseTwiceAtEachLevel() throws {
        let firstCourse = try #require(catalog.courses.first)
        let skill = try #require(catalog.skills.first { $0.course != firstCourse.id })
        let levels = known.cookLog.map(\.lesson.level)
        #expect(Set(known.cookLog.map(\.lesson.skill)) == [skill.id])
        #expect(levels.count == skill.levels.count * KnownState.cooksAtEachLevel)
        #expect(levels == levels.sorted())
        #expect(known.cookLog.allSatisfy { $0.session.result == .finished(quizCorrect: true) })
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

    /// The server's last answer for this cook comes with the state, so Home shows progress before any call.
    @Test func itKeepsTheReturningCooksSnapshot() throws {
        let store = InMemoryProgressStore()
        try known.write(to: store)
        #expect(try store.progressSnapshot() == (try FakeProgressFixture.returning.snapshot()))
    }
}
