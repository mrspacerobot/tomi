import Foundation
import TomiCore

extension PlayerModel {
    /// Logs the finished cook, with the quiz, and forgets the bookmark.
    func finish() {
        log(.finished(quizCorrect: answeredRight))
    }

    /// Logs a cook stopped early, which counts for nothing, and forgets the bookmark.
    func stop() {
        log(.stoppedEarly)
    }

    func bookmark(_ step: Int) {
        var active = ActiveLesson(lesson: dish.id, revision: brief.revision)
        active.swaps = brief.swaps
        active.ingredients = Set(brief.ingredients.map { IngredientID(rawValue: $0.id.rawValue) })
        active.currentStep = step
        attempt { try store.saveActiveLesson(active, at: .now) }
    }

    /// The moment and the zone are taken as the cook is saved, so the server counts it on the day it was cooked
    /// where it was cooked, however far the cook travels before it is sent. It is sent at once, when it can be.
    private func log(_ result: CookResult) {
        let lesson = CookedLesson(id: dish.id, skill: dish.skill, level: dish.level)
        var session = CookSession(date: .now, result: result, weeklyGoal: profile.weeklyGoal)
        session.timeZone = cookingZone
        let account = auth.accountID()
        attempt {
            try store.add(CookEntry(id: UUID(), lesson: lesson, session: session, account: account))
            try store.clearActiveLesson()
        }
        uploader.upload()
    }

    private func attempt(_ saving: () throws -> Void) {
        do {
            try saving()
        } catch {
            Self.logger.error("The cook could not be saved: \(String(describing: error), privacy: .public)")
        }
    }
}
