/// Made-up stats for previews and the component gallery: the three columns the mockups show.
extension Stat {
    static var samples: [Stat] {
        [sampleStreak, sampleRank, sampleLevel]
    }

    /// The share of the way to the next level the sample stats stand for: 183 of 250.
    nonisolated static let sampleProgress = 0.732

    private static var sampleStreak: Stat {
        Stat(
            label: String(localized: .sampleStatStreakLabel),
            value: String(localized: .sampleStatStreakValue),
            detail: String(localized: .sampleStatStreakDetail)
        )
    }

    private static var sampleRank: Stat {
        Stat(
            label: String(localized: .sampleStatRankLabel),
            value: String(localized: .sampleStatRankValue),
            detail: String(localized: .sampleStatRankDetail)
        )
    }

    private static var sampleLevel: Stat {
        Stat(
            label: String(localized: .sampleStatLevelLabel),
            value: String(localized: .sampleStatLevelValue),
            detail: String(localized: .sampleStatLevelDetail)
        )
    }
}
