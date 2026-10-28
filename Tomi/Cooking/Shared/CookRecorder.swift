import Foundation
import OSLog
import TomiCore

/// Writes the cook of a suggestion to the outbox, once: finished when the last step is done, stopped early when the
/// cook leaves before that. The moment and the zone are taken as the cook is saved, so the server counts it on the
/// day it was cooked where it was cooked. It is saved before anything else happens with it and sent at once, when
/// it can be.
@Observable
final class CookRecorder {
    static let logger = Logger(category: .progress)

    private let session: CookingSession
    private let weeklyGoal: Int
    private let store: any ProgressStore
    private let uploader: CookEntryUploader
    private let auth: any AuthService
    private var isRecorded = false
    private var firstTried: Date?
    /// The zone a cook is saved in. The phone's own zone while cooking; a test sets a fixed one.
    var cookingZone = TimeZone.current

    init(session: CookingSession, flow: AppFlowModel) {
        self.session = session
        weeklyGoal = flow.profile.profile.weeklyGoal
        store = flow.services.store
        uploader = flow.uploader
        auth = flow.services.auth
    }

    @discardableResult
    func finish() -> Bool {
        record(.finished(quizCorrect: false))
    }

    /// A no-op once the cook is finished, so leaving the steps for the quiz never undoes the finish.
    @discardableResult
    func stop() -> Bool {
        record(.stoppedEarly)
    }

    private func record(_ result: CookResult) -> Bool {
        if isRecorded { return true }
        guard save(entry(for: result)) else { return false }
        isRecorded = true
        uploader.upload()
        return true
    }

    private func entry(for result: CookResult) -> CookEntry {
        let cookedAt = firstTried ?? .now
        firstTried = cookedAt
        var cook = CookSession(date: cookedAt, result: result, weeklyGoal: weeklyGoal)
        cook.timeZone = cookingZone
        return session.suggestion.cooked(id: session.entryID, session: cook, account: auth.accountID())
    }

    private func save(_ entry: CookEntry) -> Bool {
        do {
            try store.add(entry)
            return true
        } catch {
            Self.logger.error("The cook could not be saved: \(String(describing: error), privacy: .public)")
            return false
        }
    }
}
