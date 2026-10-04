import Foundation

@testable import TomiCore

extension CookEntry {
    /// A finished cook with its own new id, at level 1 on 5 October unless a test says otherwise.
    static func fixture(_ skill: SkillID, level: Int = 1, on day: DateComponents = .october(5)) -> CookEntry {
        let lesson = CookedLesson(id: "a-lesson", skill: skill, level: level)
        let date = StreakTestCalendar().date(day)
        let session = CookSession(date: date, result: .finished(quizCorrect: true), weeklyGoal: 2)
        return CookEntry(id: UUID(), lesson: lesson, session: session)
    }

    /// The same cook, abandoned before the last step.
    func stoppedBeforeTheEnd() -> CookEntry {
        let stopped = CookSession(date: session.date, result: .stoppedEarly, weeklyGoal: session.weeklyGoal)
        return CookEntry(id: id, lesson: lesson, session: stopped)
    }

    /// The same cook, with the quiz at the end answered wrong.
    func withTheQuizWrong() -> CookEntry {
        CookEntry(
            id: id,
            lesson: lesson,
            skill: skill,
            level: level,
            date: date,
            stoppedEarly: stoppedEarly,
            quizCorrect: false,
            weeklyGoal: weeklyGoal
        )
    }

    func with(weeklyGoal: Int) -> CookEntry {
        let changed = CookSession(date: session.date, result: session.result, weeklyGoal: weeklyGoal)
        return CookEntry(id: id, lesson: lesson, session: changed)
    }

    func with(lesson id: LessonID) -> CookEntry {
        let changed = CookedLesson(id: id, skill: lesson.skill, level: lesson.level)
        return CookEntry(id: self.id, lesson: changed, session: session)
    }
}
