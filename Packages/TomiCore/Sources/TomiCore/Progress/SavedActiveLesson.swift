import Foundation

/// The bookmark of a lesson in progress, one value per stored field, under the stored field's name. It is kept only
/// because stored fields are permanent: the bundled lesson player that wrote it is gone, and nothing reads it now.
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
}
