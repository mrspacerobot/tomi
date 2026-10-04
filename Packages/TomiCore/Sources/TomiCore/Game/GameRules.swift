/// Every number of the game, in one place. No view or service may hard-code one of these.
///
/// The streak is the everyday hook; rank is the slow, long goal, so it is paced in weeks and months, not cooks.
/// Pacing assumes a regular cook: about 60 XP a cook, three or four cooks a week.
public enum GameRules {
    public static let xpPerCook = 50
    public static let xpForCorrectQuiz = 10

    /// XP at which each named rank begins, in `RankTitle` order. Each step is roughly twice the last:
    /// Commis in the first week, Saucier after a month, Chef after four months, Toque after about a year.
    public static let rankThresholds = [0, 150, 400, 900, 1_800, 3_300, 6_000, 11_000]

    /// Past Toque the ladder never ends: a new tier (Toque II, III...) every this much XP, about one a season.
    public static let xpPerTierPastTop = 3_000

    /// The streak counts weeks in which the cook cooked on at least this many days. Asked in onboarding.
    public static let weeklyGoalOptions = 1...7
    public static let defaultWeeklyGoal = 3

    /// Finished cooks at one level of a skill before that level is complete and the next one opens.
    public static let cooksToCompleteLevel = 2

    /// What one finished cook earns: the cook itself, plus the quiz when it was answered right.
    public static func xpForFinishedCook(quizCorrect: Bool) -> Int {
        if quizCorrect {
            return xpPerCook + xpForCorrectQuiz
        }
        return xpPerCook
    }

    static func clampedWeeklyGoal(_ goal: Int) -> Int {
        min(max(goal, weeklyGoalOptions.lowerBound), weeklyGoalOptions.upperBound)
    }

    static func isLevelComplete(cooks: Int) -> Bool {
        cooks >= cooksToCompleteLevel
    }
}
