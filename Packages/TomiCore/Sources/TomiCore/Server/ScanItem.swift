/// One thing the server's model saw in a fridge photo.
public struct ScanItem: Hashable, Codable, Sendable {
    /// What the model called it, in its own words.
    public let label: String
    /// The ingredient of the server's table it matched, or nil when it matched none.
    /// Only an item with an ingredient can be used for tonight's special.
    public let ingredient: NamedOption?
    /// How sure the model was, from 0 to 1.
    public let confidence: Double

    public init(label: String, ingredient: NamedOption?, confidence: Double) {
        self.label = label
        self.ingredient = ingredient
        self.confidence = confidence
    }
}
