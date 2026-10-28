import Foundation
import Testing
import TomiCore

@testable import Tomi

/// The state UI tests start from.
@MainActor
@Suite struct KnownStateTests {
    let known = KnownState()

    /// One technique, cooked twice at each of its levels, and nothing else.
    @Test func theCookCookedOneTechniqueTwiceAtEachLevel() {
        let levels = known.cookLog.map(\.lesson.level)
        #expect(Set(known.cookLog.map(\.lesson.skill)) == [KnownState.skill])
        #expect(levels.count == KnownState.levels * KnownState.cooksAtEachLevel)
        #expect(levels == levels.sorted())
        #expect(known.cookLog.allSatisfy { $0.session.result == .finished(quizCorrect: true) })
    }

    @Test func theCooksAreCooksOfAGraphRecipeSoTheyWaitToBeSent() {
        #expect(known.cookLog.allSatisfy { $0.isSendable })
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
