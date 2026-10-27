import Foundation

/// Reads a stored cook back. A record that lacks anything a cook entry needs is not an entry: it gives nil,
/// counts for nothing, and stays in the store untouched, so nothing is lost and nothing is guessed.
extension SavedCookEntry {
    public var entry: CookEntry? {
        guard let stableID, let lesson = cookedLesson, let session else {
            return nil
        }
        return CookEntry(id: stableID, lesson: lesson, session: session, account: account)
    }

    /// The skill and level are kept as saved, known or not: the progress rules leave out what the menu lacks.
    private var cookedLesson: CookedLesson? {
        guard let lesson, let skill, let level else {
            return nil
        }
        return CookedLesson(id: LessonID(rawValue: lesson), skill: SkillID(rawValue: skill), level: level)
    }

    private var session: CookSession? {
        guard let date, let result, let weeklyGoal else {
            return nil
        }
        var session = CookSession(date: date, result: result, weeklyGoal: weeklyGoal)
        session.timeZone = readableZone
        return session
    }

    /// A zone this phone cannot read is no zone: the cook still counts, and is sent with the zone of the upload.
    private var readableZone: TimeZone? {
        guard let timeZone else {
            return nil
        }
        return TimeZone(identifier: timeZone)
    }

    /// A record that does not say how the cook ended is not read, so it can never earn anything.
    /// A finished cook without a quiz answer earns the cook alone.
    private var result: CookResult? {
        guard let stoppedEarly else {
            return nil
        }
        if stoppedEarly {
            return .stoppedEarly
        }
        return .finished(quizCorrect: quizCorrect ?? false)
    }
}
