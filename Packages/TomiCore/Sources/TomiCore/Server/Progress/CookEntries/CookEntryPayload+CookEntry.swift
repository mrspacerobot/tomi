import Foundation

extension CookEntryPayload {
    /// A cook of the phone's log, with the zone it was cooked in. How the quiz went is left out on purpose.
    public init(entry: CookEntry, timeZone: TimeZone) {
        schemaVersion = Self.currentSchemaVersion
        id = entry.id
        cookedAt = ServerInstant(entry.session.date)
        self.timeZone = timeZone.identifier
        dish = .lesson(entry.lesson.id)
        skill = entry.lesson.skill
        level = entry.lesson.level
        outcome = CookOutcome(entry.session.result)
        weeklyGoal = entry.session.weeklyGoal
    }
}
