/// A level of a technique, by its number, with its name in the cook's language.
public struct NamedLevel: Hashable, Codable, Sendable {
    /// Counts from 1, as in the skill catalog.
    public let number: Int
    public let name: String

    public init(number: Int, name: String) {
        self.number = number
        self.name = name
    }
}
