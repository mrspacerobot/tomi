import Foundation

/// What Home shows of the cook's progress: the server's last snapshot exactly as it was sent, and a kind note
/// when it may be behind. Nothing here adds a cook, XP or a rank: unsent cooks are only counted for the note.
public struct ShownProgress: Hashable, Sendable {
    /// Nil before the first snapshot arrived. Home then shows no numbers at all, never zeros.
    public let snapshot: ProgressSnapshot?
    /// False once the snapshot's week has ended, because its days belong to a week that is over.
    public let showsThisWeek: Bool
    public let note: ProgressNote?

    public init(snapshot: ProgressSnapshot?, situation: ProgressSituation, now: Date) {
        self.snapshot = snapshot
        showsThisWeek = Self.weekIsOn(in: snapshot, at: now)
        note = Self.note(for: snapshot, showsThisWeek: showsThisWeek, situation: situation)
    }

    private static func weekIsOn(in snapshot: ProgressSnapshot?, at now: Date) -> Bool {
        guard let snapshot else {
            return false
        }
        return now < snapshot.streak.weekEndsAt.date
    }

    /// Only offline: online, unsent cooks go at once and a new snapshot is on its way.
    private static func note(
        for snapshot: ProgressSnapshot?,
        showsThisWeek: Bool,
        situation: ProgressSituation
    ) -> ProgressNote? {
        guard situation.isOffline else { return nil }
        guard snapshot != nil else { return .showsWhenOnline }
        if situation.unsentCooks > 0 { return .unsentCooks(situation.unsentCooks) }
        if !showsThisWeek { return .thisWeekWhenOnline }
        return nil
    }
}
