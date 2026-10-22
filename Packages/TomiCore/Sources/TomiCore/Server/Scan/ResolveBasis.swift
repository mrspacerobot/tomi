/// How sure the server is about what a typed word means.
public enum ResolveBasis: String, Hashable, Codable, Sendable {
    /// One ingredient, and it is that one.
    case exact
    /// Several could be meant. The cook picks one of the candidates.
    case ambiguous
    /// Nothing the server knows. It cannot be used for tonight's special.
    case noMatch = "none"
}
