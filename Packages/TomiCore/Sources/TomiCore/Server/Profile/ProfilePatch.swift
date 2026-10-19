import Foundation

/// The body of `PATCH /v1/profile`: the version the app last read and only the fields the cook changed.
/// A field cleared by the cook is sent as null, which is how the server is told to clear it.
public struct ProfilePatch: Sendable {
    public static let versionField = "version"
    public static let allowWeakerRestrictionsField = "allowWeakerRestrictions"

    public let version: Int
    public let before: CookProfile
    public let after: CookProfile
    /// Set only after the cook confirmed on screen that they want a diet or avoid item removed.
    /// Without it the server refuses such a change with `409 weakens_restrictions`.
    public var allowsWeakerRestrictions = false

    public init(version: Int, before: CookProfile, after: CookProfile) {
        self.version = version
        self.before = before
        self.after = after
    }

    /// Whether the cook changed anything at all. Nothing need be sent when they did not.
    public var hasChanges: Bool {
        before != after
    }

    /// The JSON body, with its keys sorted so the same change always gives the same bytes.
    public func body() throws -> Data {
        var fields = try changedFields()
        fields[Self.versionField] = version
        if allowsWeakerRestrictions {
            fields[Self.allowWeakerRestrictionsField] = true
        }
        return try JSONSerialization.data(withJSONObject: fields, options: [.sortedKeys])
    }

    func changedFields() throws -> [String: Any] {
        let old = try Self.fields(of: before)
        var changed: [String: Any] = [:]
        for (name, value) in try Self.fields(of: after) where !Self.isSame(value, old[name]) {
            changed[name] = value
        }
        return changed
    }

    static func fields(of profile: CookProfile) throws -> [String: Any] {
        let data = try JSONEncoder().encode(profile)
        guard let fields = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            return [:]
        }
        return fields
    }

    private static func isSame(_ value: Any, _ other: Any?) -> Bool {
        guard let value = value as? NSObject, let other = other as? NSObject else {
            return false
        }
        return value.isEqual(other)
    }
}
