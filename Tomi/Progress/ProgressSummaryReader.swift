import Foundation
import TomiCore

/// Reads the saved profile and cook log and has TomiCore work out the progress to show.
struct ProgressSummaryReader {
    let store: any ProgressStore
    /// Nil only if the library has no menu that can be read. The mastered count is then left out.
    let catalog: SkillCatalog?
    /// The cook's own calendar, which tells the weeks of the streak apart.
    let calendar: Calendar

    /// The cook's progress at this moment. Throws when saved data cannot be read:
    /// the caller must then say so, and never show the progress of an empty store instead.
    func summary(at now: Date) throws -> ProgressSummary {
        let profile = try store.profile()
        let log = try store.cookLog()
        let goal = profile.weeklyGoal
        let game = GameStateRules(calendar: calendar).gameState(for: log, goal: goal, now: now)
        let mastered = masteredCount(in: log, experience: profile.experience)
        return ProgressSummary(game: game, masteredCount: mastered)
    }

    private func masteredCount(in log: [CookEntry], experience: Experience) -> Int? {
        guard let catalog else {
            return nil
        }
        let rules = ProgressRules(catalog: catalog, experience: experience)
        return rules.progress(for: log).masteredCount
    }
}
