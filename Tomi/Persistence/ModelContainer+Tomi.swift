import Foundation
import SwiftData

extension ModelContainer {
    /// The container for everything Tomi saves. The four record types are the whole layout.
    static func tomi(at location: StoreLocation) throws -> ModelContainer {
        let records: [any PersistentModel.Type] = [
            ProfileRecord.self, CookLogRecord.self, ActiveLessonRecord.self, ProgressSnapshotRecord.self,
        ]
        let schema = Schema(records)
        let configuration = try location.configuration(for: schema)
        let container = try ModelContainer(for: schema, configurations: [configuration])
        try container.checkItIsKept(asAskedBy: configuration, at: location)
        return container
    }

    /// SwiftData does not always throw when it cannot make the store file: it can hand back a store in memory
    /// instead, which reads as empty and forgets every save. That would look like a cook with no answers,
    /// The configuration can already say memory before the container opens, so the requested location decides
    /// whether memory is allowed. A file that became memory counts as a store that did not open.
    private func checkItIsKept(asAskedBy asked: ModelConfiguration, at location: StoreLocation) throws {
        if location == .memory {
            return
        }
        let isInMemory = configurations.contains { $0.isStoredInMemoryOnly }
        let hasFile = FileManager.default.fileExists(atPath: asked.url.path)
        if isInMemory || !hasFile {
            throw ProgressStoreError.unavailable
        }
    }
}
