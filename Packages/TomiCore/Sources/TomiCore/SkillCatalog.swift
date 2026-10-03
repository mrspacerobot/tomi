/// Every technique Tomi teaches, grouped into courses, in menu order.
/// It is content, not code: it ships in the lesson library and is read with `decode(from:)`.
public struct SkillCatalog: Hashable, Codable, Sendable {
    /// The catalog layout this build understands. Bump it, and the validator, when the layout changes.
    public static let supportedSchemaVersion = 1

    public let schemaVersion: Int
    /// Increases with every published library, so a newer download can be told from the bundled copy.
    public let libraryVersion: Int
    public let courses: [Course]
    public let skills: [Skill]

    public func skill(_ id: SkillID) -> Skill? {
        skills.first { $0.id == id }
    }

    public func skills(in course: CourseID) -> [Skill] {
        skills.filter { $0.course == course }
    }
}
