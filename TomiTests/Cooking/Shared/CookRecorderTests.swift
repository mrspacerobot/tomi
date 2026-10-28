import Foundation
import Testing
import TomiCore

@testable import Tomi

/// What the guided steps write to the outbox when a cook ends.
@MainActor
@Suite struct CookRecorderTests {
    let store = InMemoryProgressStore()

    @Test func aFinishedCookIsSavedUnderTheEntryIdTheQuizUses() throws {
        let session = try cookingSession()
        let recorder = try recorder(for: session)
        recorder.finish()
        let saved = try #require(try store.cookLog().first)
        #expect(saved.id == session.entryID)
        #expect(saved.session.result == .finished(quizCorrect: false))
        #expect(saved.lesson.id.rawValue == session.suggestion.recipeID.rawValue)
        #expect(saved.lesson.graphVersion == session.suggestion.graphVersion)
        #expect(saved.account == FakeAuthService.account)
    }

    @Test func aCookThatLeavesEarlyIsSavedAsStoppedEarly() throws {
        let recorder = try recorder(for: try cookingSession())
        recorder.stop()
        #expect(try store.cookLog().map(\.session.result) == [.stoppedEarly])
    }

    /// Leaving the steps for the quiz fires the stop after the finish; it must not undo or repeat it.
    @Test func aCookIsSavedOnceWhateverHappensAfterTheFinish() throws {
        let recorder = try recorder(for: try cookingSession())
        recorder.finish()
        recorder.stop()
        recorder.finish()
        #expect(try store.cookLog().map(\.session.result) == [.finished(quizCorrect: false)])
    }

    @Test func aCookIsSavedWithTheZoneItWasCookedIn() throws {
        let tokyo = try #require(TimeZone(identifier: "Asia/Tokyo"))
        let recorder = try recorder(for: try cookingSession())
        recorder.cookingZone = tokyo
        recorder.finish()
        #expect(try store.cookLog().first?.session.timeZone == tokyo)
    }

    @Test func aFinishedCookIsWaitingToBeSentForTheAccountThatCookedIt() throws {
        try recorder(for: try cookingSession()).finish()
        let waiting = try store.pendingCookEntries(for: FakeAuthService.account)
        #expect(waiting.count == 1)
    }

    @Test func aFailedSaveCanRetryTheSameEntry() throws {
        let failing = FailFirstCookStore(store: store)
        let services = AppServices.fake(store: failing, signedIn: true)
        let recorder = CookRecorder(session: try cookingSession(), flow: AppFlowModel(services: services))
        #expect(!recorder.finish())
        #expect(try store.cookLog().isEmpty)
        #expect(recorder.finish())
        #expect(try store.cookLog().first == failing.failedEntry)
    }

    @Test func aCookCanContinueAfterAStoppedSaveFails() throws {
        let failing = FailFirstCookStore(store: store)
        let services = AppServices.fake(store: failing, signedIn: true)
        let recorder = CookRecorder(session: try cookingSession(), flow: AppFlowModel(services: services))
        #expect(!recorder.stop())
        #expect(recorder.finish())
        let saved = try #require(try store.cookLog().first)
        #expect(saved.id == failing.failedEntry?.id)
        #expect(saved.session.result == .finished(quizCorrect: false))
    }

    private func cookingSession() throws -> CookingSession {
        CookingSession(suggestion: try FakeGuidedSuggestion.read(profile: CookProfile()))
    }

    private func recorder(for session: CookingSession) throws -> CookRecorder {
        let services = AppServices.fake(store: store, signedIn: true)
        return CookRecorder(session: session, flow: AppFlowModel(services: services))
    }
}
