import Testing

@testable import TomiCore

/// The shape of the ladder as a whole: every XP belongs to exactly one rank, and the steps grow.
@Suite struct RankLadderTests {
    let thresholds = GameRules.rankThresholds
    let top = GameRules.rankThresholds.last ?? 0

    /// Every XP a cook can hold, from zero to five Toque tiers past the top.
    var everyXP: ClosedRange<Int> { 0...(top + 5 * GameRules.xpPerTierPastTop) }

    @Test func everyNamedRankHasAThresholdStartingAtZero() {
        #expect(thresholds.count == RankTitle.allCases.count)
        #expect(thresholds.first == 0)
    }

    @Test func eachNamedStepCostsRoughlyTwiceTheOneBefore() {
        let steps = zip(thresholds.dropFirst(), thresholds).map { $0 - $1 }
        for (step, previous) in zip(steps.dropFirst(), steps) {
            #expect((1.5...2.5).contains(Double(step) / Double(previous)), "\(previous) then \(step)")
        }
    }

    @Test func everyXPFallsInsideItsRank() {
        for xp in everyXP {
            let rank = Rank.forXP(xp)
            #expect(rank.xp == xp)
            #expect(rank.startsAt <= xp && xp < rank.nextAt, "\(xp)")
            #expect((0..<1).contains(rank.progress), "\(xp)")
        }
    }

    @Test func eachRankEndsExactlyWhereAHigherOneBegins() {
        for xp in everyXP {
            let rank = Rank.forXP(xp)
            let next = Rank.forXP(rank.nextAt)
            #expect(next.startsAt == rank.nextAt, "\(xp)")
            #expect((next.title, next.tier) > (rank.title, rank.tier), "\(xp)")
        }
    }

    @Test func moreXPNeverMeansALowerRank() {
        let ranks = everyXP.map(Rank.forXP)
        #expect(zip(ranks.dropFirst(), ranks).allSatisfy { ($0.title, $0.tier) >= ($1.title, $1.tier) })
    }

    @Test func progressIsTheShareOfTheWayToTheNextRank() {
        let commis = Rank.forXP(GameRules.rankThresholds[1])
        let halfway = commis.startsAt + (commis.nextAt - commis.startsAt) / 2
        #expect(commis.progress == 0)
        #expect(Rank.forXP(halfway).progress == 0.5)
        #expect(Rank.forXP(top + GameRules.xpPerTierPastTop / 4).progress == 0.25)
    }
}
