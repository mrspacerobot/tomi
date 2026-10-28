import Foundation
import TomiCore

/// UI test store that fails one cook write while leaving every other operation unchanged.
final class FailFirstCookStore: ProgressStore {
    private let store: any ProgressStore
    private var shouldFail = true
    private(set) var failedEntry: CookEntry?

    init(store: any ProgressStore) { self.store = store }
    func profile() throws -> CookProfile { try store.profile() }
    func saveProfile(_ profile: CookProfile, at moment: Date) throws { try store.saveProfile(profile, at: moment) }
    func cookLog() throws -> [CookEntry] { try store.cookLog() }
    func add(_ entry: CookEntry) throws {
        if shouldFail {
            shouldFail = false
            failedEntry = entry
            throw ProgressStoreError.unavailable
        }
        try store.add(entry)
    }
    func pendingCookEntries(for account: String) throws -> [CookEntry] {
        try store.pendingCookEntries(for: account)
    }
    func forgetCookEntries(ids: Set<UUID>) throws { try store.forgetCookEntries(ids: ids) }
    func markCookEntryRefused(id: UUID, code: CookEntryProblem) throws {
        try store.markCookEntryRefused(id: id, code: code)
    }
    func progressSnapshot() throws -> ProgressSnapshot? { try store.progressSnapshot() }
    func progressSnapshot(for account: String) throws -> ProgressSnapshot? { try store.progressSnapshot(for: account) }
    func saveProgressSnapshot(_ body: Data, at moment: Date) throws {
        try store.saveProgressSnapshot(body, at: moment)
    }
    func saveProgressSnapshot(_ body: Data, at moment: Date, for account: String) throws {
        try store.saveProgressSnapshot(body, at: moment, for: account)
    }
}
