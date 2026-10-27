import Foundation
import Testing
import TomiCore

@testable import Tomi

/// The rank name the Home progress column shows, including the tier earned past the top named rank.
@MainActor
@Suite struct RankWordsTests {
    @Test func aNamedRankShowsOnlyItsTitle() {
        let rank = Rank.forXP(0)
        #expect(rank.words == String(localized: .rankNovice))
    }

    @Test func theFirstToqueTierShowsOnlyTheTitle() {
        let rank = Rank.forXP(GameRules.rankThresholds.last!)
        #expect(rank.tier == 1)
        #expect(rank.words == String(localized: .rankToque))
    }

    @Test func eachToqueTierPastTheFirstShowsItsNumber() {
        let toque = GameRules.rankThresholds.last!
        let second = Rank.forXP(toque + GameRules.xpPerTierPastTop)
        let third = Rank.forXP(toque + 2 * GameRules.xpPerTierPastTop)
        #expect(second.words == String(localized: .homeRankTiered(String(localized: .rankToque), 2)))
        #expect(third.words == String(localized: .homeRankTiered(String(localized: .rankToque), 3)))
        #expect(second.words != third.words)
    }
}
