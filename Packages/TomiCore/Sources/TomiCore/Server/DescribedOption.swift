/// One entry of a list the server sends, with a name and a line that explains it.
/// Diets, experience answers and units come like this.
public struct DescribedOption: Identifiable, Hashable, Codable, Sendable {
    public let id: OptionID
    public let name: String
    public let summary: String

    public init(id: OptionID, name: String, summary: String) {
        self.id = id
        self.name = name
        self.summary = summary
    }
}
