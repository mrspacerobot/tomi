/// One fixed order for the cook log, so that reading it never depends on the order the store hands records over.
extension CookEntry {
    /// Oldest first. Entries of the same moment are ordered by id, and two copies of one id that disagree,
    /// which a log written once never holds, by what they say, so the copy that is kept is always the same one.
    func comesInLog(before other: CookEntry) -> Bool {
        if session.date != other.session.date {
            return session.date < other.session.date
        }
        return orderWords.lexicographicallyPrecedes(other.orderWords)
    }

    private var orderWords: [String] {
        [
            id.uuidString,
            resultWord,
            String(session.weeklyGoal),
            lesson.id.rawValue,
            lesson.skill.rawValue,
            String(lesson.level),
        ]
    }

    /// Only used to order copies that disagree. The copy that earns least comes first and is the one kept.
    private var resultWord: String {
        switch session.result {
        case .stoppedEarly: "0-stopped-early"
        case .finished(let quizCorrect):
            if quizCorrect {
                "2-finished-quiz-right"
            } else {
                "1-finished-quiz-wrong"
            }
        }
    }
}
