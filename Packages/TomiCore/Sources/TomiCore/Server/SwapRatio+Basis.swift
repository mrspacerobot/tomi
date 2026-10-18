extension SwapRatio {
    /// What the two sides of a ratio are counted in.
    public enum Basis: String, Sendable {
        case weight
        case volume
        case count
    }

    /// The basis, or nil when the graph names one this build does not know. The ratio is then shown without it.
    public var basis: Basis? {
        Basis(rawValue: by)
    }
}
