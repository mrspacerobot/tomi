import Foundation
import SwiftData
import TomiCore

/// The cook records in the store: the cook log, which is also the outbox of cooks the server has not acknowledged.
/// Nothing in the store is unique, so iCloud can deliver a second copy of a cook. Every change reaches every copy,
/// and reading hands over every record and lets TomiCore decide.
struct CookLogRecords {
    let context: ModelContext

    func records() throws -> [CookLogRecord] {
        try context.fetch(FetchDescriptor<CookLogRecord>())
    }

    /// A cook that is already in the store is not written again.
    func add(_ entry: CookEntry) throws {
        let isSaved = try records().contains { $0.stableID == entry.id }
        if !isSaved {
            context.insert(CookLogRecord(SavedCookEntry(entry)))
        }
    }

    func forget(ids: Set<UUID>) throws {
        for record in try copies(of: ids) {
            context.delete(record)
        }
    }

    func markRefused(id: UUID, code: CookEntryProblem) throws {
        for record in try copies(of: [id]) {
            record.refusedCode = code.rawValue
        }
    }

    func clear() throws {
        for record in try records() {
            context.delete(record)
        }
    }

    private func copies(of ids: Set<UUID>) throws -> [CookLogRecord] {
        try records().filter { record in
            guard let id = record.stableID else {
                return false
            }
            return ids.contains(id)
        }
    }
}
