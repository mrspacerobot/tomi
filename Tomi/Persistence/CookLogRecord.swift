import Foundation
import SwiftData
import TomiCore

/// One cook in the store. `SavedCookEntry` in TomiCore says what each field holds and how it is read.
/// A record is written once, and changed only to mark it refused by the server. It is deleted once the server holds
/// a copy that counts. No total is stored: XP and progress are worked out by the server.
///
/// The layout is kept safe for iCloud: every property is optional, nothing is unique, and it only ever grows.
/// The name of this type and of every property is permanent once released: never rename or remove one.
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
    var refusedCode: String?
    var timeZone: String?

    init(_ saved: SavedCookEntry) {
        stableID = saved.stableID
        lesson = saved.lesson
        skill = saved.skill
        level = saved.level
        date = saved.date
        stoppedEarly = saved.stoppedEarly
        quizCorrect = saved.quizCorrect
        weeklyGoal = saved.weeklyGoal
        refusedCode = saved.refusedCode
        timeZone = saved.timeZone
    }
}
