import Foundation
import SwiftData
import TomiCore

@testable import Tomi

/// A fresh SwiftData store for one test, in memory unless the test asks for a file,
/// with a way to put records in behind the store's back, as iCloud would.
@MainActor
struct StoreFixture {
    let container: ModelContainer
    let store: SwiftDataProgressStore

    init(at location: StoreLocation = .memory) throws {
        container = try ModelContainer.tomi(at: location)
        store = SwiftDataProgressStore(container: container)
    }

    /// A store file in a folder of its own, so a test can open it a second time.
    static func temporaryFile() throws -> StoreLocation {
        let folder = FileManager.default.temporaryDirectory.appending(path: UUID().uuidString)
        try FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)
        return .file(folder.appending(path: "Test.store"))
    }

    func insertProfile(_ profile: CookProfile, changedOnOctober day: Int) throws {
        let record = ProfileRecord()
        record.stableID = UUID()
        record.updatedAt = .october(day)
        record.write(SavedProfile(profile))
        try insert(record)
    }

    func insertBookmark(_ lesson: ActiveLesson, changedOnOctober day: Int) throws {
        let record = ActiveLessonRecord()
        record.stableID = UUID()
        record.updatedAt = .october(day)
        record.write(SavedActiveLesson(lesson))
        try insert(record)
    }

    func insertCook(_ saved: SavedCookEntry) throws {
        try insert(CookLogRecord(saved))
    }

    func count<Record: PersistentModel>(of type: Record.Type) throws -> Int {
        try container.mainContext.fetchCount(FetchDescriptor<Record>())
    }

    private func insert(_ record: some PersistentModel) throws {
        container.mainContext.insert(record)
        try container.mainContext.save()
    }
}
