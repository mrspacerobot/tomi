import Foundation
import TomiCore

extension CookEntry {
    /// A finished cook with its own new id, at level 1 with the quiz right, on that day of October.
    static func fixture(_ skill: SkillID, onOctober day: Int) -> CookEntry {
        let lesson = CookedLesson(id: "a-lesson", skill: skill, level: 1)
        let session = CookSession(date: .october(day), result: .finished(quizCorrect: true), weeklyGoal: 3)
        return CookEntry(id: UUID(), lesson: lesson, session: session)
    }

    /// The same cook, made in the zone with that IANA identifier.
    func cooked(in zone: String) -> CookEntry {
        var located = session
        located.timeZone = TimeZone(identifier: zone)!
        return CookEntry(id: id, lesson: lesson, session: located)
    }
}
