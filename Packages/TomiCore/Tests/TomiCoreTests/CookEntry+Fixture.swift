import Foundation

@testable import TomiCore

extension CookEntry {
    /// A finished cook with its own new id, at level 1 on 5 October unless a test says otherwise.
    static func fixture(_ skill: SkillID, level: Int = 1, on day: DateComponents = .october(5)) -> CookEntry {
        CookEntry(
            id: UUID(),
            lesson: "a-lesson",
            skill: skill,
            level: level,
            date: StreakTestCalendar().date(day),
            stoppedEarly: false,
            quizCorrect: true,
            weeklyGoal: 2
        )
    }

    /// The same cook, abandoned before the last step.
    func stoppedBeforeTheEnd() -> CookEntry {
        CookEntry(
            id: id,
            lesson: lesson,
            skill: skill,
            level: level,
            date: date,
            stoppedEarly: true,
            quizCorrect: quizCorrect,
            weeklyGoal: weeklyGoal
        )
    }

    func with(weeklyGoal: Int) -> CookEntry {
        CookEntry(
            id: id,
            lesson: lesson,
            skill: skill,
            level: level,
            date: date,
            stoppedEarly: stoppedEarly,
            quizCorrect: quizCorrect,
            weeklyGoal: weeklyGoal
        )
    }
}
