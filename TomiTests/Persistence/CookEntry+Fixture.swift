import Foundation
import TomiCore

@testable import Tomi

extension CookEntry {
    /// The account every fixture cook belongs to: the one the fake sign-in signs in.
    static let fixtureAccount = FakeAuthService.account

    /// A finished cook with its own new id, at level 1 with the quiz right, on that day of October.
    static func fixture(_ skill: SkillID, onOctober day: Int) -> CookEntry {
        let lesson = CookedLesson(id: "a-lesson", skill: skill, level: 1)
        let session = CookSession(date: .october(day), result: .finished(quizCorrect: true), weeklyGoal: 3)
        return CookEntry(id: UUID(), lesson: lesson, session: session, account: fixtureAccount)
    }

    /// The same cook, made in the zone with that IANA identifier.
    func cooked(in zone: String) -> CookEntry {
        var located = session
        located.timeZone = TimeZone(identifier: zone)!
        return CookEntry(id: id, lesson: lesson, session: located, account: account)
    }

    /// The same cook, made by another account.
    func cooked(by account: String?) -> CookEntry {
        CookEntry(id: id, lesson: lesson, session: session, account: account)
    }
}
