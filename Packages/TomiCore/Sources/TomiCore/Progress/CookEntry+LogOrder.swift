/// One fixed order for the cook log, so that reading it never depends on the order the store hands records over.
extension CookEntry {
    /// Oldest first. Entries of the same moment are ordered by id, and two copies of one id that disagree,
    /// which a log written once never holds, by what they say, so the copy that is kept is always the same one.
    /// How the cook ended comes before the zone, so the copy that earns least stays the one kept whatever the zone.
    func comesInLog(before other: CookEntry) -> Bool {
        if session.date != other.session.date {
            return session.date < other.session.date
        }
        return orderKey < other.orderKey
    }

    private var orderKey: LogOrderKey {
        LogOrderKey(
            words: [id.uuidString, lesson.id.rawValue, lesson.skill.rawValue],
            numbers: [resultRank, session.weeklyGoal, lesson.level],
            zone: zoneIdentifier
        )
    }

    /// A cook saved before zones were recorded comes before one with a zone.
    private var zoneIdentifier: String {
        guard let zone = session.timeZone else {
            return ""
        }
        return zone.identifier
    }

    /// Only used to order copies that disagree. The copy that earns least comes first and is the one kept.
    private var resultRank: Int {
        switch session.result {
        case .stoppedEarly: 0
        case .finished(let quizCorrect):
            if quizCorrect {
                2
            } else {
                1
            }
        }
    }
}

/// Every field that tells two copies apart. Any fixed order will do, as long as it is the same everywhere.
private struct LogOrderKey: Comparable {
    let words: [String]
    let numbers: [Int]
    /// Only breaks a tie that nothing else does.
    let zone: String

    static func < (left: LogOrderKey, right: LogOrderKey) -> Bool {
        if left.words != right.words {
            return left.words.lexicographicallyPrecedes(right.words)
        }
        if left.numbers != right.numbers {
            return left.numbers.lexicographicallyPrecedes(right.numbers)
        }
        return left.zone < right.zone
    }
}
