import Foundation
import Testing

@testable import TomiCore

/// The bar to the next rank is drawn from the numbers the server gave. It adds no XP and works out no rank.
@Suite struct RankBarTests {
    func bar(xp: Int, startsAt: Int, nextAt: Int) -> RankBar {
        RankBar(xp: xp, rank: SnapshotRank(id: "commis", name: "Commis", tier: 1, startsAt: startsAt, nextAt: nextAt))
    }

    @Test func theExampleIsTwoHundredOfTwoHundredAndFifty() throws {
        let snapshot = try ServerJSON.decode(ProgressSnapshot.self, from: ProgressJSON.snapshot)
        let bar = snapshot.rankBar
        #expect(bar.earned == 200)
        #expect(bar.needed == 250)
        #expect(bar.remaining == 50)
        #expect(bar.fraction == 0.8)
    }

    @Test func atTheStartOfARankTheBarIsEmpty() {
        #expect(bar(xp: 150, startsAt: 150, nextAt: 400).fraction == 0)
    }

    /// A server answer the phone cannot draw is drawn empty or full, never past either end.
    @Test func aBarOutsideItsRankStaysWithinItsEnds() {
        #expect(bar(xp: 100, startsAt: 150, nextAt: 400).fraction == 0)
        #expect(bar(xp: 500, startsAt: 150, nextAt: 400).fraction == 1)
        #expect(bar(xp: 500, startsAt: 150, nextAt: 400).remaining == 0)
        #expect(bar(xp: 100, startsAt: 150, nextAt: 400).earned == 0)
    }

    @Test func aRankWithNoRoomDrawsAnEmptyBar() {
        let empty = bar(xp: 150, startsAt: 150, nextAt: 150)
        #expect(empty.fraction == 0)
        #expect(empty.needed == 0)
    }
}
