import Foundation

extension CookEntryPayload {
    /// A cook of the phone's log, with the zone it was cooked in. How the quiz went is left out on purpose.
    /// Nil for a cook with no graph recipe, such as one of a bundled lesson: the server takes no other dish.
    public init?(entry: CookEntry, timeZone: TimeZone) {
        guard let dish = entry.dish else {
            return nil
        }
        self.init(entry: entry, dish: dish, timeZone: timeZone)
    }

    private init(entry: CookEntry, dish: CookedDish, timeZone: TimeZone) {
        schemaVersion = Self.currentSchemaVersion
        id = entry.id
        cookedAt = ServerInstant(entry.session.date)
        self.timeZone = timeZone.identifier
        self.dish = dish
        skill = entry.lesson.skill
        level = entry.lesson.level
        outcome = CookOutcome(entry.session.result)
        weeklyGoal = entry.session.weeklyGoal
    }
}
