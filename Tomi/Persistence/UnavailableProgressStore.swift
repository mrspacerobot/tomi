import Foundation
import TomiCore

/// The store Tomi holds when the real one could not be opened. Every call fails, so nothing can read
/// a default profile out of it and mistake that for a cook who eats everything.
/// Previews and tests use it to reach the screens that say saved data is unavailable.
struct UnavailableProgressStore: ProgressStore {
    func profile() throws -> CookProfile {
        throw ProgressStoreError.unavailable
    }

    func saveProfile(_ profile: CookProfile, at moment: Date) throws {
        throw ProgressStoreError.unavailable
    }

    func cookLog() throws -> [CookEntry] {
        throw ProgressStoreError.unavailable
    }

    func add(_ entry: CookEntry) throws {
        throw ProgressStoreError.unavailable
    }

    func activeLesson() throws -> ActiveLesson? {
        throw ProgressStoreError.unavailable
    }

    func saveActiveLesson(_ lesson: ActiveLesson, at moment: Date) throws {
        throw ProgressStoreError.unavailable
    }

    func clearActiveLesson() throws {
        throw ProgressStoreError.unavailable
    }

    func pendingCookEntries(for account: String) throws -> [CookEntry] {
        throw ProgressStoreError.unavailable
    }

    func forgetCookEntries(ids: Set<UUID>) throws {
        throw ProgressStoreError.unavailable
    }

    func markCookEntryRefused(id: UUID, code: CookEntryProblem) throws {
        throw ProgressStoreError.unavailable
    }

    func progressSnapshot() throws -> ProgressSnapshot? {
        throw ProgressStoreError.unavailable
    }

    func saveProgressSnapshot(_ body: Data, at moment: Date) throws {
        throw ProgressStoreError.unavailable
    }
}
