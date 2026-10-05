import Foundation
import Testing
import TomiCore

@testable import Tomi

/// What the screens are handed: a summary, or nothing when saved data cannot be read.
@MainActor
@Suite struct SavedProgressModelTests {
    let calendar = Calendar(identifier: .gregorian)

    @Test func aReadableStoreGivesASummary() {
        let model = model(over: InMemoryProgressStore())
        #expect(model.summary?.game.xp == 0)
    }

    @Test func aStoreThatCannotBeReadGivesNoSummarySoNothingIsShown() {
        let model = model(over: UnavailableProgressStore())
        #expect(model.summary == nil)
    }

    @Test func refreshingReadsTheCookLogAgain() throws {
        let store = InMemoryProgressStore()
        let model = model(over: store)
        try store.add(.fixture("eggs", onOctober: 5))
        #expect(model.summary?.game.xp == 0)
        model.refresh(at: .october(8))
        #expect(model.summary?.game.xp == GameRules.xpForFinishedCook(quizCorrect: true))
    }

    private func model(over store: any ProgressStore) -> SavedProgressModel {
        let reader = ProgressSummaryReader(store: store, catalog: BundledLibrary.catalog(), calendar: calendar)
        return SavedProgressModel(reader: reader, now: .october(8))
    }
}
