/// A swap in an offer's safe plan: one ingredient of the source recipe out, another in.
public struct OfferSwap: Hashable, Decodable, Sendable {
    public let removed: NamedOption
    public let added: NamedOption
    /// How much of the new ingredient stands in for the old, or nil when the graph gives no ratio.
    public let ratio: SwapRatio?
    /// What the swap changes about the dish, in the cook's language, or nil when it changes nothing worth saying.
    public let caveat: String?

    public init(removed: NamedOption, added: NamedOption, ratio: SwapRatio? = nil, caveat: String? = nil) {
        self.removed = removed
        self.added = added
        self.ratio = ratio
        self.caveat = caveat
    }
}
