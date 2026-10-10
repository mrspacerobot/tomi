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
        var active = ActiveLesson(lesson: dish.id, revision: offer.revision)
        active.swaps = offer.swaps.map(\.applied)
        active.ingredients = Set(offer.ingredients.map { IngredientID(rawValue: $0.id.rawValue) })
        active.currentStep = step
        attempt { try store.saveActiveLesson(active, at: .now) }
    }

    private func log(_ result: CookResult) {
        let lesson = CookedLesson(id: dish.id, skill: dish.skill, level: dish.level)
        let session = CookSession(date: .now, result: result, weeklyGoal: profile.weeklyGoal)
        attempt {
            try store.add(CookEntry(id: UUID(), lesson: lesson, session: session))
            try store.clearActiveLesson()
        }
    }

    private func attempt(_ saving: () throws -> Void) {
        do {
            try saving()
        } catch {
            Self.logger.error("The cook could not be saved: \(String(describing: error), privacy: .public)")
        }
    }
}
