import Foundation

/// The cook's profile as it lies in the store: one value per stored field, under the stored field's name.
/// It is the phone's copy of the profile Tomi's server keeps, which uses the same field names.
/// Every field may be missing, because an older app wrote fewer of them and iCloud delivers what it has.
/// Field names are permanent once released: add fields, never rename or remove one, even one the app
/// no longer reads.
public struct SavedProfile: Hashable, Sendable, StampedRecord {
    public var stableID: UUID?
    public var updatedAt: Date?
    /// A diet id of the server, or nil when the cook eats everything.
    public var diet: String?
    /// Avoid item ids.
    public var avoid: [String]?
    /// Cuisine ids, one list for each answer. A cuisine in no list has no answer.
    public var cuisinesLoved: [String]?
    public var cuisinesToTry: [String]?
    public var cuisinesNever: [String]?
    /// Ingredient ids.
    public var cupboardStaples: [String]?
    /// Equipment ids, or nil while the cook has not answered. An empty list is an answer of its own.
    public var equipment: [String]?
    /// A raw value of `Experience`.
    public var experience: String?
    public var servings: Int?
    /// A raw value of `Units`, or nil while the cook has not picked.
    public var units: String?
    public var weeklyGoal: Int?
    /// A skill id, or nil when the menu order decides what is next.
    public var focusSkill: String?
    public var onboardingDone: Bool?

    public init() {}
}
