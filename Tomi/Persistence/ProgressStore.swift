import Foundation
import TomiCore

/// What Tomi remembers between launches: a copy of the cook's profile from the server, the cook log, the lesson in
/// progress and the last progress snapshot. Screens and services ask this, and never care whether it is the store on
/// the phone or a fake.
///
/// Nothing here is a total. XP, rank, streak and mastery come from the server's snapshot, kept as it was received.
///
/// Every read throws when the store cannot be opened or read. The caller must then show that saved data
/// is unavailable, and never carry on with a default profile.
protocol ProgressStore {
    /// The last copy of the server's profile, or the defaults when nothing has been saved yet.
    /// It feeds cooking offline; it never decides what the cook may eat.
    func profile() throws -> CookProfile

    /// Saves the copy of the server's profile, replacing whatever was saved before.
    func saveProfile(_ profile: CookProfile, at moment: Date) throws

    /// Every cook once, oldest first, however often an entry was saved and in whatever order.
    func cookLog() throws -> [CookEntry]

    /// Adds a cook to the log. Entries are written once and never changed.
    func add(_ entry: CookEntry) throws

    /// The bookmark of the lesson in progress, or nil when there is none that can be read.
    /// Before it is shown, `ActiveLesson.resumed(from:)` builds the dish again from the library.
    /// The bookmark is forgotten whenever the cook's diet or avoid list changes (`ProfileCache`).
    func activeLesson() throws -> ActiveLesson?

    /// Saves the bookmark, replacing the one saved before.
    func saveActiveLesson(_ lesson: ActiveLesson, at moment: Date) throws

    /// Forgets the lesson in progress, when it is finished or given up.
    func clearActiveLesson() throws

    /// The outbox: every cook the server has neither acknowledged nor refused, each once, oldest first.
    func pendingCookEntries() throws -> [CookEntry]

    /// Deletes every copy of these cooks, once the server holds a copy that counts. An unknown id changes nothing.
    func forgetCookEntries(ids: Set<UUID>) throws

    /// Marks every copy of the cook refused with the server's code. It stays in the log and is never sent again.
    func markCookEntryRefused(id: UUID, code: CookEntryProblem) throws

    /// The snapshot received last, read as the server sent it. Nil when there is none or it cannot be read:
    /// the caller then says progress shows once online, and never shows zeros.
    func progressSnapshot() throws -> ProgressSnapshot?

    /// Keeps the server's snapshot JSON exactly as it arrived, replacing the one received before.
    func saveProgressSnapshot(_ body: Data, at moment: Date) throws
}
