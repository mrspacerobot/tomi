/// The kind line Home shows when the server's progress may be behind what the cook has done.
public enum ProgressNote: Hashable, Sendable {
    /// These cooks are on the phone and count once the server has them.
    case unsentCooks(Int)
    /// No snapshot has arrived yet, so there are no numbers to show.
    case showsWhenOnline
    /// The kept snapshot's week is over, so this week's days are not known yet.
    case thisWeekWhenOnline
}
