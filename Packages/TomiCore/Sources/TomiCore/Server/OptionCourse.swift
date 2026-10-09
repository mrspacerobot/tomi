/// A course of the menu as the server sends it with the options, names already in the cook's language.
public struct OptionCourse: Identifiable, Hashable, Codable, Sendable {
    public let id: CourseID
    public let title: String
    public var skills: [OptionSkill] = []

    public init(id: CourseID, title: String) {
        self.id = id
        self.title = title
    }
}
