import Foundation

@testable import TomiCore

extension CookEntry {
    /// The account every fixture cook belongs to unless a test says otherwise.
    static let fixtureAccount = "cook-a"

    /// A finished cook with its own new id, at level 1 on 5 October unless a test says otherwise.
    static func fixture(_ skill: SkillID, level: Int = 1, on day: DateComponents = .october(5)) -> CookEntry {
        let lesson = CookedLesson(id: "a-lesson", skill: skill, level: level)
        let date = StreakTestCalendar().date(day)
        let session = CookSession(date: date, result: .finished(quizCorrect: true), weeklyGoal: 2)
        return CookEntry(id: UUID(), lesson: lesson, session: session, account: fixtureAccount)
    }

    /// The same cook, abandoned before the last step.
    func stoppedBeforeTheEnd() -> CookEntry {
        let stopped = CookSession(date: session.date, result: .stoppedEarly, weeklyGoal: session.weeklyGoal)
        return CookEntry(id: id, lesson: lesson, session: stopped, account: account)
    }

    /// The same cook, with the quiz at the end answered wrong.
    func withTheQuizWrong() -> CookEntry {
        let result = CookResult.finished(quizCorrect: false)
        let wrong = CookSession(date: session.date, result: result, weeklyGoal: session.weeklyGoal)
        return CookEntry(id: id, lesson: lesson, session: wrong, account: account)
    }

    func with(weeklyGoal: Int) -> CookEntry {
        let changed = CookSession(date: session.date, result: session.result, weeklyGoal: weeklyGoal)
        return CookEntry(id: id, lesson: lesson, session: changed, account: account)
    }

    /// The same cook, made in the zone with that IANA identifier.
    func cooked(in zone: String) -> CookEntry {
        var located = session
        located.timeZone = TimeZone(identifier: zone)!
        return CookEntry(id: id, lesson: lesson, session: located, account: account)
    }

    func with(lesson id: LessonID) -> CookEntry {
        let changed = CookedLesson(id: id, skill: lesson.skill, level: lesson.level)
        return CookEntry(id: self.id, lesson: changed, session: session, account: account)
    }

    /// The same cook, made by another account.
    func cooked(by account: String?) -> CookEntry {
        CookEntry(id: id, lesson: lesson, session: session, account: account)
    }
}
