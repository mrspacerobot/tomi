/// What the server made of one typed word.
public struct ResolvedLabel: Hashable, Codable, Sendable {
    public let label: String
    public let basis: ResolveBasis
    /// The ingredient for an exact match, the choices for an ambiguous one, and nothing otherwise.
    public let candidates: [NamedOption]

    public init(label: String, basis: ResolveBasis, candidates: [NamedOption]) {
        self.label = label
        self.basis = basis
        self.candidates = candidates
    }

    /// The ingredient to add without asking: only an exact match with exactly one candidate.
    public var exactIngredient: NamedOption? {
        guard basis == .exact, candidates.count == 1 else {
            return nil
        }
        return candidates.first
    }
}
