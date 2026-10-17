/// The profile as `GET /v1/profile` and `PATCH /v1/profile` send it back, with the version the next change
/// must name. A `409 version_conflict` carries one of these too, with the profile as it is now.
public struct ProfileEnvelope: Hashable, Codable, Sendable {
    public let version: Int
    public let schemaVersion: Int
    public let profile: CookProfile

    public init(version: Int, schemaVersion: Int, profile: CookProfile) {
        self.version = version
        self.schemaVersion = schemaVersion
        self.profile = profile
    }
}
