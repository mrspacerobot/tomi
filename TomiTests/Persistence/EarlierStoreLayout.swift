import Foundation
import SwiftData

@testable import Tomi

/// The cook record as the store laid it out before the outbox fields and the snapshot record were added (#161),
/// so a test can write a store file the way an earlier app version did.
enum EarlierStoreLayout {
    @Model
    final class CookLogRecord {
        var stableID: UUID?
        var lesson: String?
        var skill: String?
        var level: Int?
        var date: Date?
        var stoppedEarly: Bool?
        var quizCorrect: Bool?
        var weeklyGoal: Int?

        init(id: UUID, skill: String, date: Date) {
            stableID = id
            lesson = "a-lesson"
            self.skill = skill
            level = 1
            self.date = date
            stoppedEarly = false
            quizCorrect = true
            weeklyGoal = 3
        }
    }

    /// Writes one finished cook into a new store file of the earlier layout.
    @MainActor
    static func writeCook(_ cook: CookLogRecord, to location: StoreLocation) throws {
        let schema = Schema([CookLogRecord.self])
        let configuration = try location.configuration(for: schema)
        let container = try ModelContainer(for: schema, configurations: [configuration])
        container.mainContext.insert(cook)
        try container.mainContext.save()
    }
}
