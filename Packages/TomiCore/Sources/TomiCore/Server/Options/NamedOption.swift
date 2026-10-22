/// One entry of a list the server sends, with its name already in the cook's language.
public struct NamedOption: Identifiable, Hashable, Codable, Sendable {
    public let id: OptionID
    public let name: String

    public init(id: OptionID, name: String) {
        self.id = id
        self.name = name
    }
}
