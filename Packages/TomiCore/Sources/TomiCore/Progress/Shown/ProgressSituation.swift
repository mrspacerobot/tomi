/// What the phone knows besides the snapshot: how many cooks wait to be sent, and whether the server could be
/// reached the last time it was asked.
public struct ProgressSituation: Hashable, Sendable {
    /// Before the server was asked, or after it answered.
    public static let online = ProgressSituation(unsentCooks: 0, isOffline: false)

    /// Cooks saved on the phone that the server has neither acknowledged nor refused.
    public let unsentCooks: Int
    /// The server could not be reached the last time it was asked.
    public let isOffline: Bool

    public init(unsentCooks: Int, isOffline: Bool) {
        self.unsentCooks = unsentCooks
        self.isOffline = isOffline
    }
}
