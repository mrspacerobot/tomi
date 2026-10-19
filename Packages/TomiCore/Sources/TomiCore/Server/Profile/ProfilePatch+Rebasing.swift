import Foundation

extension ProfilePatch {
    /// The same change made again on the profile as it is now, after the server answered `version_conflict`.
    /// Only the fields the cook changed are taken over; every other answer stays as the other device left it.
    /// Whether the cook confirmed a weaker restriction is not carried over: the new change is judged afresh.
    public func rebased(on current: ProfileEnvelope) throws -> ProfilePatch {
        var fields = try Self.fields(of: current.profile)
        for (name, value) in try changedFields() {
            fields[name] = value
        }
        let data = try JSONSerialization.data(withJSONObject: fields)
        let after = try JSONDecoder().decode(CookProfile.self, from: data)
        return ProfilePatch(version: current.version, before: current.profile, after: after)
    }
}
