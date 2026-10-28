import Foundation
import TomiCore

/// The saved state UI tests start from, so that what they assert is known in advance.
/// A cook who answered "comfortable", finished onboarding, and has cooked one invented technique, twice at each
/// of its levels, getting each quiz right. The cooks are written as unsent cooks; what they are worth
/// is the server's to say, so the state also holds the fake server's returning snapshot (`KnownState+Writing`).
struct KnownState {
    /// Not a recipe of any graph. The entries record their own skill and level.
    static let lesson = LessonID(rawValue: "known-state-lesson")
    /// The graph version the seeded cooks name, so they are cooks of a graph recipe and wait to be sent.
    static let graphVersion = "known-state-graph"

    /// The technique the seeded cooks name and how many levels it has. Invented, like the fake server's menu.
    static let skill = SkillID(rawValue: "known-state-skill")
    static let levels = 3

    /// How many cooks the log holds at each level. A fixed shape of the seed, not a rule of the game.
    static let cooksAtEachLevel = 2

    var profile: CookProfile {
        var profile = CookProfile()
        profile.experience = .comfortable
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
        var lessons: [CookedLesson] = []
        for level in 1...Self.levels {
            let lesson = CookedLesson(id: Self.lesson, skill: Self.skill, level: level, graphVersion: Self.graphVersion)
            lessons += Array(repeating: lesson, count: Self.cooksAtEachLevel)
        }
        return lessons
    }

    private func entry(of lesson: CookedLesson, on date: Date) -> CookEntry {
        let goal = profile.weeklyGoal
        let session = CookSession(date: date, result: .finished(quizCorrect: true), weeklyGoal: goal)
        return CookEntry(id: UUID(), lesson: lesson, session: session, account: FakeAuthService.account)
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
