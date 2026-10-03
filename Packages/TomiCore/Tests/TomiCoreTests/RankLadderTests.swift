import Testing

@testable import TomiCore

@Suite struct RankLadderTests {
    /// A cook with the quiz right, the usual case.
    let typicalCook = GameRules.xpPerCook + GameRules.xpForCorrectQuiz
    let top = GameRules.rankThresholds.last!
    let tierStep = GameRules.xpPerTierPastTop

    @Test func everyNamedRankHasAThreshold() {
        #expect(GameRules.rankThresholds.count == RankTitle.allCases.count)
        #expect(GameRules.rankThresholds.first == 0)
    }

    @Test func aNewCookIsANovice() {
        #expect(Rank.forXP(0).title == .novice)
        #expect(Rank.forXP(-10).title == .novice)
    }

    @Test func theFirstPromotionComesWithinThreeCooks() {
        #expect(Rank.forXP(3 * typicalCook).title == .commis)
    }

    @Test func everyNamedStepCostsMoreThanTheOneBefore() {
        let steps = zip(GameRules.rankThresholds.dropFirst(), GameRules.rankThresholds).map { $0 - $1 }
        #expect(zip(steps.dropFirst(), steps).allSatisfy { $0 > $1 })
    }

    @Test func toqueTakesAboutAYearOfCookingThreeOrFourTimesAWeek() {
        let cooks = Double(top) / Double(typicalCook)
        #expect((45...60).contains(cooks / 3.5))
    }

    @Test func pastToqueTheLadderNeverEnds() {
        let rank = Rank.forXP(top + 3 * tierStep + 1)
        #expect(rank.title == .toque)
        #expect(rank.tier == 4)
        #expect(rank.nextAt == top + 4 * tierStep)
    }

    @Test func progressIsTheShareOfTheWayToTheNextRank() {
        let commis = Rank.forXP(150)
        #expect(Rank.forXP(commis.startsAt + (commis.nextAt - commis.startsAt) / 2).progress == 0.5)
        #expect(commis.progress == 0)
    }

    @Test func moreXPNeverMeansALowerRank() {
        let ranks = stride(from: 0, through: top + 5 * tierStep, by: 50).map(Rank.forXP)
        #expect(zip(ranks.dropFirst(), ranks).allSatisfy { ($0.title, $0.tier) >= ($1.title, $1.tier) })
    }
}
