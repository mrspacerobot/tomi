import Foundation
import Testing

@testable import TomiCore

/// What Home shows: the server's last snapshot as it was sent, and a kind note when it may be behind.
/// No cook, XP or rank is ever added on the phone.
@Suite struct ShownProgressTests {
    let utc = UTCMoment()

    var snapshot: ProgressSnapshot {
        get throws { try ServerJSON.decode(ProgressSnapshot.self, from: ProgressJSON.snapshot) }
    }

    /// Inside the example's week, which runs from 25 October 23:00 to 1 November 23:00 in UTC.
    var duringTheWeek: Date { utc.date(.october(27), hour: 12) }

    @Test func onlineTheSnapshotIsShownWithNoNote() throws {
        let shown = ShownProgress(snapshot: try snapshot, situation: .online, now: duringTheWeek)
        #expect(shown.snapshot == (try snapshot))
        #expect(shown.showsThisWeek)
        #expect(shown.note == nil)
    }

    @Test func offlineWithUnsentCooksTheNoteCountsThemAndTheXPStaysTheServers() throws {
        let situation = ProgressSituation(unsentCooks: 2, isOffline: true)
        let shown = ShownProgress(snapshot: try snapshot, situation: situation, now: duringTheWeek)
        #expect(shown.note == .unsentCooks(2))
        #expect(shown.snapshot?.xp == 350)
        #expect(shown.snapshot?.rank == (try snapshot).rank)
    }

    @Test func offlineWithEveryCookSentThereIsNoNote() throws {
        let situation = ProgressSituation(unsentCooks: 0, isOffline: true)
        let shown = ShownProgress(snapshot: try snapshot, situation: situation, now: duringTheWeek)
        #expect(shown.note == nil)
    }

    /// Unsent cooks are sent as soon as the server answers, so online they need no note.
    @Test func onlineUnsentCooksNeedNoNote() throws {
        let situation = ProgressSituation(unsentCooks: 3, isOffline: false)
        let shown = ShownProgress(snapshot: try snapshot, situation: situation, now: duringTheWeek)
        #expect(shown.note == nil)
    }

    @Test func withoutASnapshotOfflineTheNoteSaysProgressShowsOnlineAndNoNumbersAreGiven() {
        let situation = ProgressSituation(unsentCooks: 1, isOffline: true)
        let shown = ShownProgress(snapshot: nil, situation: situation, now: duringTheWeek)
        #expect(shown.snapshot == nil)
        #expect(shown.note == .showsWhenOnline)
        #expect(!shown.showsThisWeek)
    }

    /// While the first answer is on its way there is nothing to say yet.
    @Test func withoutASnapshotBeforeTheServerAnsweredThereIsNoNote() {
        let shown = ShownProgress(snapshot: nil, situation: .online, now: duringTheWeek)
        #expect(shown.note == nil)
    }
}
