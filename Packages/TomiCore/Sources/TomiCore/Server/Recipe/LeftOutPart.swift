/// A part of the dish the cook goes without, and the foods the recipe would have used for it.
public struct LeftOutPart: Identifiable, Hashable, Decodable, Sendable {
    /// The graph's id of the part, such as `enrichment`.
    public let part: String
    /// A name the cook can read, from the food the part would have held.
    public let name: String
    public let ingredients: [NamedOption]

    public var id: String {
        part
    }
}
