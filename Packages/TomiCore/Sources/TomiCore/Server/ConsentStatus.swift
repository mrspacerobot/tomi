/// Whether the cook agreed to one purpose, as `GET /v1/consents` sends it.
/// A consent counts only for the text version the cook was shown; a newer text must be agreed to again.
public struct ConsentStatus: Hashable, Codable, Sendable {
    /// The purpose as the server names it. A purpose this build does not know is kept and never shown.
    public let purposeName: String
    public let currentVersion: Int
    public let agreed: Bool

    public init(purpose: ConsentPurpose, currentVersion: Int, agreed: Bool) {
        self.purposeName = purpose.rawValue
        self.currentVersion = currentVersion
        self.agreed = agreed
    }

    public var purpose: ConsentPurpose? {
        ConsentPurpose(rawValue: purposeName)
    }

    enum CodingKeys: String, CodingKey {
        case purposeName = "purpose"
        case currentVersion
        case agreed
    }
}
