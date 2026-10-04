import Foundation

/// One line of the cook log: a lesson the cook started, and how it went.
/// The log is the source of truth. Progress, streak and XP are computed from its entries, never stored beside them.
/// Entries are written once and never changed, so two devices can merge their logs by id.
public struct CookEntry: Identifiable, Hashable, Sendable {
    /// Made once when the cook is logged. The same id on two devices is the same cook.
    public let id: UUID
    public let lesson: CookedLesson
    public let session: CookSession

    public init(id: UUID, lesson: CookedLesson, session: CookSession) {
        self.id = id
        self.lesson = lesson
        self.session = session
    }
}
