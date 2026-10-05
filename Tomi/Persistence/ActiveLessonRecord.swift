import Foundation
import SwiftData

/// The bookmark of the lesson in progress in the store.
/// `SavedActiveLesson` in TomiCore says what each field holds and how it is read.
///
/// The layout is kept safe for iCloud: every property is optional, nothing is unique, and it only ever grows.
/// The name of this type and of every property is permanent once released: never rename or remove one.
@Model
final class ActiveLessonRecord {
    var stableID: UUID?
    var updatedAt: Date?
    var lesson: String?
    var lessonRevision: Int?
    var swappedOut: [String]?
    var swappedIn: [String]?
    var ingredients: [String]?
    var currentStep: Int?

    init() {}
}
