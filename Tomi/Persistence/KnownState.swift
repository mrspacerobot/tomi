import Foundation
import TomiCore

/// The saved state UI tests start from, so that what they assert is known in advance.
/// It is built from the menu it is given and names no technique:
/// a cook who answered "comfortable", finished onboarding, and has since cooked every level
/// of the first technique after the first course until it was complete, getting each quiz right.
/// So the first course is mastered by the profile and one more technique by the cook log.
struct KnownState {
    /// Not a lesson of any library. The entries record their own skill and level, which is what counts.
    static let lesson = LessonID(rawValue: "known-state-lesson")

    let catalog: SkillCatalog

    var profile: CookProfile {
        var profile = CookProfile()
        profile.preferences.experience = .comfortable
        profile.isOnboardingDone = true
        return profile
    }

    /// One cook a day from the first day, in the order a cook would work through the levels.
    var cookLog: [CookEntry] {
        var entries: [CookEntry] = []
        for lesson in lessonsToCook {
            if let date = Self.evening(ofDay: entries.count) {
                entries.append(entry(of: lesson, on: date))
            }
        }
        return entries
    }

    private var lessonsToCook: [CookedLesson] {
        guard let skill = firstSkillAfterTheFirstCourse else {
            return []
        }
        var lessons: [CookedLesson] = []
        for level in skill.levels {
            let lesson = CookedLesson(id: Self.lesson, skill: skill.id, level: level.number)
            lessons += Array(repeating: lesson, count: GameRules.cooksToCompleteLevel)
        }
        return lessons
    }

    private var firstSkillAfterTheFirstCourse: Skill? {
        guard let firstCourse = catalog.courses.first else {
            return nil
        }
        return catalog.skills.first { $0.course != firstCourse.id }
    }

    private func entry(of lesson: CookedLesson, on date: Date) -> CookEntry {
        let goal = profile.preferences.weeklyGoal
        let session = CookSession(date: date, result: .finished(quizCorrect: true), weeklyGoal: goal)
        return CookEntry(id: UUID(), lesson: lesson, session: session)
    }

    /// Six in the evening, so many days after Monday 5 October 2026. A fixed day, never the clock.
    static func evening(ofDay day: Int) -> Date? {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = .gmt
        let firstDay = DateComponents(year: 2026, month: 10, day: 5, hour: 18)
        guard let firstEvening = calendar.date(from: firstDay) else {
            return nil
        }
        return calendar.date(byAdding: .day, value: day, to: firstEvening)
    }
}
