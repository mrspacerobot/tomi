import Foundation
import SwiftData

/// The cook's profile in the store. `SavedProfile` in TomiCore says what each field holds and how it is read.
///
/// The layout is kept safe for iCloud: every property is optional, nothing is unique, and it only ever grows.
/// The name of this type and of every property is permanent once released: never rename or remove one.
@Model
final class ProfileRecord {
    var stableID: UUID?
    var updatedAt: Date?
    var diet: String?
    var avoid: [String]?
    var cuisinesLoved: [String]?
    var cuisinesToTry: [String]?
    var cuisinesNever: [String]?
    var cupboardStaples: [String]?
    var cupboardAnswered: Bool?
    var equipment: [String]?
    var experience: String?
    var servings: Int?
    var units: String?
    var weeklyGoal: Int?
    var focusSkill: String?
    var onboardingDone: Bool?

    init() {}
}
