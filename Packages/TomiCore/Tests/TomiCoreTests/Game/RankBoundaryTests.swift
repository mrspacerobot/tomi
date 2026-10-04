import Testing

@testable import TomiCore

/// Exactly where each rank begins, so an off-by-one at a threshold cannot hide.
@Suite struct RankBoundaryTests {
    static let namedRanks = Array(zip(RankTitle.allCases, GameRules.rankThresholds))
    let top = GameRules.rankThresholds.last ?? 0
    let tierStep = GameRules.xpPerTierPastTop

    @Test func aNewCookIsANoviceAtTheFootOfTheLadder() {
        let novice = Rank(title: .novice, tier: 1, xp: 0, startsAt: 0, nextAt: GameRules.rankThresholds[1])
        #expect(Rank.forXP(0) == novice)
        #expect(Rank.forXP(-10) == novice)
    }

    @Test(arguments: namedRanks)
    func aNamedRankBeginsAtItsThreshold(title: RankTitle, threshold: Int) {
        let rank = Rank.forXP(threshold)
        #expect(rank.title == title)
        #expect(rank.tier == 1)
        #expect(rank.startsAt == threshold)
    }

    @Test(arguments: namedRanks.dropFirst())
    func oneXPShortOfARankIsStillTheOneBelow(title: RankTitle, threshold: Int) {
        let below = Rank.forXP(threshold - 1)
        #expect(below.title < title)
        #expect(below.nextAt == threshold)
    }

    @Test func toqueIsTheTopNamedRankAndLeadsToToqueII() {
        let toque = Rank(title: .toque, tier: 1, xp: top, startsAt: top, nextAt: top + tierStep)
        #expect(Rank.forXP(top) == toque)
    }

    @Test(arguments: 2...6)
    func eachToqueTierBeginsOneStepAfterTheLast(tier: Int) {
        let start = top + (tier - 1) * tierStep
        let rank = Rank(title: .toque, tier: tier, xp: start, startsAt: start, nextAt: start + tierStep)
        #expect(Rank.forXP(start) == rank)
        #expect(Rank.forXP(start - 1).tier == tier - 1)
    }

    @Test func farPastToqueTheTiersKeepCounting() {
        let rank = Rank.forXP(top + 99 * tierStep + 1)
        #expect(rank.title == .toque)
        #expect(rank.tier == 100)
        #expect(rank.nextAt == top + 100 * tierStep)
    }
}
