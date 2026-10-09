/// The body of `PUT /v1/consents/{purpose}`: the version of the text the cook was shown and agreed to.
public struct ConsentAgreement: Hashable, Codable, Sendable {
    public let version: Int

    public init(version: Int) {
        self.version = version
    }
}
