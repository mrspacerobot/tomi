/// How far the cook is with one skill. Computed from the cook log by `ProgressRules`, never stored.
public struct SkillProgress: Hashable, Sendable {
    public let skill: SkillID
    /// One entry per level of the skill, in catalog order.
    public let levels: [LevelProgress]
    /// Prerequisites whose first level is not complete yet, in the order the catalog lists them.
    public let missingPrerequisites: [SkillID]

    /// A skill is served, meaning unlocked, when no prerequisite is missing.
    public var isServed: Bool {
        missingPrerequisites.isEmpty
    }

    /// A skill is mastered when all of its levels are complete.
    public var isMastered: Bool {
        levels.allSatisfy(\.isComplete)
    }

    /// One state for the menu. Mastered comes first, so finished work still shows
    /// if a newer catalog adds a prerequisite to a skill the cook has already mastered.
    public var status: SkillStatus {
        if isMastered {
            return .mastered
        }
        if isServed {
            return .served
        }
        return .locked(missing: missingPrerequisites)
    }

    /// The level the cook is on: the first one not complete yet, or the last one once the skill is mastered.
    public var currentLevel: Int {
        if let firstIncomplete = levels.first(where: { !$0.isComplete }) {
            return firstIncomplete.number
        }
        if let last = levels.last {
            return last.number
        }
        return SkillLevel.firstNumber
    }
}
