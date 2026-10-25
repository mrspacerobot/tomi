/// The details of an error, which differ by code. Whatever cannot be read here is left out,
/// never a reason to lose the error itself.
struct APIErrorDetails: Decodable {
    /// For `version_conflict`: the profile as it is now.
    let current: ProfileEnvelope?

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        current = try? container.decodeIfPresent(ProfileEnvelope.self, forKey: .current)
    }

    enum CodingKeys: String, CodingKey {
        case current
    }
}
