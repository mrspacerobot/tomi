/// How the server ordered the offers.
public enum RankedBy: String, Hashable, Codable, Sendable {
    /// The server's model ranked them and may have written a reason for each.
    case model
    /// No model was available: fewest ingredients to buy first.
    case overlap
}
