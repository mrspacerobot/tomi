/// How many finished cooks the log holds for each level of each skill.
/// A cook counts at the level its lesson taught, whether or not that level was open at the time,
/// so the counts depend only on which entries exist and never on their order.
/// The lesson id plays no part: the entry records its own skill and level.
struct CookCounts {
    private var cooksBySkill: [SkillID: [Int: Int]] = [:]

    init(entries: [CookEntry]) {
        for entry in entries.finishedCooks {
            add(entry)
        }
    }

    func cooks(of skill: SkillID, level: Int) -> Int {
        guard let cooksByLevel = cooksBySkill[skill] else {
            return 0
        }
        guard let cooks = cooksByLevel[level] else {
            return 0
        }
        return cooks
    }

    private mutating func add(_ entry: CookEntry) {
        let lesson = entry.lesson
        var cooksByLevel = cooksBySkill[lesson.skill] ?? [:]
        let cooksSoFar = cooksByLevel[lesson.level] ?? 0
        cooksByLevel[lesson.level] = cooksSoFar + 1
        cooksBySkill[lesson.skill] = cooksByLevel
    }
}
