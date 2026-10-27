import Foundation
import SwiftData
import TomiCore

/// The store on the phone. It only moves records in and out: what they mean is decided by TomiCore,
/// which reads the cached profile, the cook log, the outbox and the last snapshot from every record, in any order.
final class SwiftDataProgressStore: ProgressStore {
    /// Kept for as long as the store lives: a context does not keep its container alive.
    private let container: ModelContainer
    private let context: ModelContext
    private let profiles: SingleRecordSlot<ProfileRecord>
    private let bookmarks: SingleRecordSlot<ActiveLessonRecord>
    private let snapshots: SingleRecordSlot<ProgressSnapshotRecord>
    private let cooks: CookLogRecords

    init(container: ModelContainer) {
        self.container = container
        context = container.mainContext
        profiles = SingleRecordSlot(context: context)
        bookmarks = SingleRecordSlot(context: context)
        snapshots = SingleRecordSlot(context: context)
        cooks = CookLogRecords(context: context)
    }

    func profile() throws -> CookProfile {
        let saved = try profiles.records().map(\.saved)
        guard let profile = saved.cachedProfile else {
            return CookProfile()
        }
        return profile
    }

    func saveProfile(_ profile: CookProfile, at moment: Date) throws {
        try saving {
            let record = try profiles.recordToWrite(at: moment)
            record.write(SavedProfile(profile))
        }
    }

    func cookLog() throws -> [CookEntry] {
        try cooks.records().map(\.saved).cookLog
    }

    /// A cook that is already in the store is not written again. A copy that iCloud brings later is read once.
    func add(_ entry: CookEntry) throws {
        try saving { try cooks.add(entry) }
    }

    func activeLesson() throws -> ActiveLesson? {
        let saved = try bookmarks.records().map(\.saved)
        guard let newest = saved.newest else {
            return nil
        }
        return newest.activeLesson
    }

    func saveActiveLesson(_ lesson: ActiveLesson, at moment: Date) throws {
        try saving {
            let record = try bookmarks.recordToWrite(at: moment)
            record.write(SavedActiveLesson(lesson))
        }
    }

    func clearActiveLesson() throws {
        try saving { try bookmarks.clear() }
    }

    func pendingCookEntries() throws -> [CookEntry] {
        try cooks.records().map(\.saved).pendingCookEntries
    }

    func forgetCookEntries(ids: Set<UUID>) throws {
        try saving { try cooks.forget(ids: ids) }
    }

    func markCookEntryRefused(id: UUID, code: CookEntryProblem) throws {
        try saving { try cooks.markRefused(id: id, code: code) }
    }

    func progressSnapshot() throws -> ProgressSnapshot? {
        try snapshots.records().map(\.saved).lastSnapshot
    }

    func saveProgressSnapshot(_ body: Data, at moment: Date) throws {
        try saving {
            let record = try snapshots.recordToWrite(at: moment)
            record.write(body: body)
        }
    }

    /// Empties the store. Only test launches call it, and never on the cook's own store.
    func erase() throws {
        try saving {
            try profiles.clear()
            try bookmarks.clear()
            try snapshots.clear()
            try cooks.clear()
        }
    }

    /// Makes the changes and saves them, or takes them all back.
    private func saving(_ changes: () throws -> Void) throws {
        try context.saveOrRollBack(changes)
    }
}
