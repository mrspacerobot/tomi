import Foundation

/// One line of the cook log: a lesson the cook started, and how it went.
/// The log is the source of truth. Progress, streak and XP are computed from its entries, never stored beside them.
/// Entries are written once and never changed, so two devices can merge their logs by id.
public struct CookEntry: Identifiable, Hashable, Sendable {
    /// Made once when the cook is logged. The same id on two devices is the same cook.
    public let id: UUID
    public let lesson: CookedLesson
    public let session: CookSession
    /// The id of the signed-in account that cooked it. Only that account's outbox sends it, so a cook saved by one
    /// cook is never credited to the next cook who signs in on the same phone. Nil when no account was known:
    /// such a cook is kept and never sent.
    public let account: String?

    public init(id: UUID, lesson: CookedLesson, session: CookSession, account: String? = nil) {
        self.id = id
        self.lesson = lesson
        self.session = session
        self.account = account
    }
}
