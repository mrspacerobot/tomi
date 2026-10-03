/// A course on Tomi's menu: a group of techniques served together, such as the sauces.
public struct Course: Identifiable, Hashable, Codable, Sendable {
    public let id: CourseID
    public let title: LocalizedText

    public init(id: CourseID, title: LocalizedText) {
        self.id = id
        self.title = title
    }
}
