import Foundation

extension Suggestion {
    /// The cook log entry for cooking this suggestion. It names the graph recipe and the graph version it came from,
    /// which is all the server takes as a dish, and keeps the id the quiz picks were recorded under. A suggestion
    /// with no graph version gives an entry that is kept and never sent.
    public func cooked(id: UUID, session: CookSession, account: String?) -> CookEntry {
        let dish = CookedLesson(
            id: LessonID(rawValue: recipeID.rawValue),
            skill: skill.id,
            level: level.number,
            graphVersion: graphVersion
        )
        return CookEntry(id: id, lesson: dish, session: session, account: account)
    }
}
