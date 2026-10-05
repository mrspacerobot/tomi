import Foundation

/// The lesson in progress as it lies in the store: one value per stored field, under the stored field's name.
/// Every field may be missing. Field names are permanent once released: add fields, never rename or remove one.
public struct SavedActiveLesson: Hashable, Sendable, StampedRecord {
    public var stableID: UUID?
    public var updatedAt: Date?
    /// The lesson id.
    public var lesson: String?
    public var lessonRevision: Int?
    /// The ingredient ids the applied swaps took out, and at the same positions the ones they put in.
    public var swappedOut: [String]?
    public var swappedIn: [String]?
    /// Tonight's ingredient ids.
    public var ingredients: [String]?
    /// Counting from 0.
    public var currentStep: Int?

    public init() {}

    public init(_ active: ActiveLesson) {
        lesson = active.lesson.rawValue
        lessonRevision = active.revision
        swappedOut = active.swaps.map(\.removed.rawValue)
        swappedIn = active.swaps.map(\.added.rawValue)
        ingredients = active.ingredients.savedIDs
        currentStep = active.currentStep
    }
}
