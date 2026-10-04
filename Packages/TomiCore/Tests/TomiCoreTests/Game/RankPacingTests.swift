import Testing

@testable import TomiCore

/// The pacing promised to a regular cook: about 60 XP a cook, three or four cooks a week.
@Suite struct RankPacingTests {
    /// A cook with the quiz right, the usual case.
    static let typicalCook = GameRules.xpPerCook + GameRules.xpForCorrectQuiz
    static let cooksPerWeek = 3.5

    /// The cook on which a regular cook reaches each named rank, from the pacing table in #63.
    static let promotionCooks: [(RankTitle, Int)] = [
        (.novice, 0), (.commis, 3), (.cook, 7), (.saucier, 15),
        (.sous, 30), (.chef, 55), (.patron, 100), (.toque, 184),
    ]

    static func weeksToEarn(_ xp: Int) -> Double {
        Double(xp) / Double(typicalCook) / cooksPerWeek
    }

    @Test func thePacingTableCoversEveryNamedRank() {
        #expect(Self.promotionCooks.map(\.0) == RankTitle.allCases)
    }

    @Test(arguments: promotionCooks.dropFirst())
    func aRegularCookIsPromotedOnThePlannedCook(title: RankTitle, cook: Int) {
        #expect(Rank.forXP(cook * Self.typicalCook).title == title)
        #expect(Rank.forXP((cook - 1) * Self.typicalCook).title < title)
    }

    @Test func evenWithoutTheQuizTheFirstPromotionComesInWeekOne() {
        #expect(Rank.forXP(4 * GameRules.xpPerCook).title >= .commis)
    }

    @Test func toqueTakesAboutAYear() {
        #expect((45...60).contains(Self.weeksToEarn(GameRules.rankThresholds.last ?? 0)))
    }

    @Test func eachToqueTierPastTheTopTakesAboutASeason() {
        #expect((11...17).contains(Self.weeksToEarn(GameRules.xpPerTierPastTop)))
    }
}
