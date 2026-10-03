extension Rank {
    /// The rank for a total of XP, following `GameRules.rankThresholds` and then Toque tiers without end.
    public static func forXP(_ xp: Int) -> Rank {
        let xp = max(xp, 0)
        let thresholds = GameRules.rankThresholds
        guard let top = thresholds.last, xp < top else {
            return tierPastTop(xp)
        }
        let index = thresholds.lastIndex { $0 <= xp } ?? 0
        let title = RankTitle.allCases[index]
        return Rank(title: title, tier: 1, xp: xp, startsAt: thresholds[index], nextAt: thresholds[index + 1])
    }

    private static func tierPastTop(_ xp: Int) -> Rank {
        let top = GameRules.rankThresholds.last ?? 0
        let step = GameRules.xpPerTierPastTop
        let tiersPast = (xp - top) / step
        let start = top + tiersPast * step
        return Rank(title: .toque, tier: tiersPast + 1, xp: xp, startsAt: start, nextAt: start + step)
    }
}
