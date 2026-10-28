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
    /// The zone a cook is saved in. The phone's own zone while cooking; a test sets a fixed one.
    var cookingZone = TimeZone.current

    init(session: CookingSession, flow: AppFlowModel) {
        self.session = session
        weeklyGoal = flow.profile.profile.weeklyGoal
        store = flow.services.store
        uploader = flow.uploader
        auth = flow.services.auth
    }

    func finish() {
        record(.finished(quizCorrect: false))
    }

    /// A no-op once the cook is finished, so leaving the steps for the quiz never undoes the finish.
    func stop() {
        record(.stoppedEarly)
    }

    private func record(_ result: CookResult) {
        guard !isRecorded else {
            return
        }
        isRecorded = true
        var cook = CookSession(date: .now, result: result, weeklyGoal: weeklyGoal)
        cook.timeZone = cookingZone
        let entry = session.suggestion.cooked(id: session.entryID, session: cook, account: auth.accountID())
        save(entry)
        uploader.upload()
    }

    private func save(_ entry: CookEntry) {
        do {
            try store.add(entry)
        } catch {
            Self.logger.error("The cook could not be saved: \(String(describing: error), privacy: .public)")
        }
    }
}
