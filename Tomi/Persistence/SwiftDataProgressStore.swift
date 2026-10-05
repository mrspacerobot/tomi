import Foundation
import SwiftData
import TomiCore

/// The store on the phone. It only moves records in and out: what they mean is decided by TomiCore,
/// which reads a profile from every profile record and a cook log from every cook record, in any order.
final class SwiftDataProgressStore: ProgressStore {
    /// Kept for as long as the store lives: a context does not keep its container alive.
    private let container: ModelContainer
    private let context: ModelContext
    private let profiles: SingleRecordSlot<ProfileRecord>
    private let bookmarks: SingleRecordSlot<ActiveLessonRecord>

    init(container: ModelContainer) {
        self.container = container
        context = container.mainContext
        profiles = SingleRecordSlot(context: context)
        bookmarks = SingleRecordSlot(context: context)
    }

    func profile() throws -> CookProfile {
        let saved = try profiles.records().map(\.saved)
        guard let profile = saved.mergedProfile else {
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
        try cookRecords().map(\.saved).cookLog
    }

    /// A cook that is already in the store is not written again. A copy that iCloud brings later is read once.
    func add(_ entry: CookEntry) throws {
        let isSaved = try cookRecords().contains { $0.stableID == entry.id }
        if isSaved {
            return
        }
        try saving {
            context.insert(CookLogRecord(SavedCookEntry(entry)))
        }
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
        try saving {
            try bookmarks.clear()
        }
    }

    /// Empties the store. Only test launches call it, and never on the cook's own store.
    func erase() throws {
        try saving {
            try profiles.clear()
            try bookmarks.clear()
            for record in try cookRecords() {
                context.delete(record)
            }
        }
    }

    private func cookRecords() throws -> [CookLogRecord] {
        try context.fetch(FetchDescriptor<CookLogRecord>())
    }

    /// Makes the changes and saves them. If either fails, the half-made changes are taken back,
    /// so the store never holds something the caller was told had failed.
    private func saving(_ changes: () throws -> Void) throws {
        do {
            try changes()
            try context.save()
        } catch {
            context.rollback()
            throw error
        }
    }
}
