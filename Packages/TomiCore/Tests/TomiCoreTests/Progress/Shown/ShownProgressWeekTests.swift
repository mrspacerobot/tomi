import Foundation
import Testing

@testable import TomiCore

/// A kept snapshot whose week has ended says nothing true about this week, so its days are hidden.
@Suite struct ShownProgressWeekTests {
    let utc = UTCMoment()

    var snapshot: ProgressSnapshot {
        get throws { try ServerJSON.decode(ProgressSnapshot.self, from: ProgressJSON.snapshot) }
    }

    @Test func theLastMomentBeforeTheWeekEndsStillShowsTheWeek() throws {
        let justBefore = utc.date(.november(1), hour: 22, minute: 59, second: 59)
        let shown = ShownProgress(snapshot: try snapshot, situation: .online, now: justBefore)
        #expect(shown.showsThisWeek)
    }

    @Test func fromTheMomentTheWeekEndsItsDaysAreHidden() throws {
        let shown = ShownProgress(snapshot: try snapshot, situation: .online, now: utc.date(.november(1), hour: 23))
        #expect(!shown.showsThisWeek)
    }

    @Test func offlineAfterTheWeekEndedTheNoteSaysThisWeekShowsOnline() throws {
        let situation = ProgressSituation(unsentCooks: 0, isOffline: true)
        let shown = ShownProgress(snapshot: try snapshot, situation: situation, now: utc.date(.november(3), hour: 9))
        #expect(!shown.showsThisWeek)
        #expect(shown.note == .thisWeekWhenOnline)
    }

    /// Both are true, and the unsent cooks are the news: they are what will count.
    @Test func unsentCooksAreNamedBeforeTheEndedWeek() throws {
        let situation = ProgressSituation(unsentCooks: 1, isOffline: true)
        let shown = ShownProgress(snapshot: try snapshot, situation: situation, now: utc.date(.november(3), hour: 9))
        #expect(!shown.showsThisWeek)
        #expect(shown.note == .unsentCooks(1))
    }
}
