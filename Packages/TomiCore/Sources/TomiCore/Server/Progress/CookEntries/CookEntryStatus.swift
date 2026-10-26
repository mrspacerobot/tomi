/// What the server did with one cook entry of a batch.
public enum CookEntryStatus: Hashable, Sendable {
    /// Stored now.
    case accepted
    /// The same id with the same body was stored before.
    case duplicate
    /// The same id with a different body was stored before. The first copy stays and counts.
    case conflict
    /// Not stored, for the permanent reasons in the result's problems. Never sent again.
    case rejected
    /// A status this app does not know yet. The entry is kept and sent again later, never dropped.
    case unknown(String)
}
