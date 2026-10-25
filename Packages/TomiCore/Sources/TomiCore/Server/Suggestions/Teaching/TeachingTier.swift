/// A known graph content review tier.
public enum TeachingTier: String, Hashable, Decodable, Sendable {
    case drafted, sourced, reviewed, verified
    case cookTested = "cook-tested"

    var isReviewed: Bool { self == .reviewed || self == .verified || self == .cookTested }
}
