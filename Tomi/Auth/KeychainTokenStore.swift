import Foundation
import Security

/// The cook's session in the Keychain, readable only on this device once it has been unlocked after a restart.
/// The session is stored as one item of JSON under the app's own service name.
nonisolated struct KeychainTokenStore: TokenStore {
    static let account = "supabase-session"

    private var service: String {
        Bundle.main.bundleIdentifier ?? ProcessInfo.processInfo.processName
    }

    func load() throws -> AuthSession? {
        var query = baseQuery
        query[kSecReturnData as String] = true
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        if status == errSecItemNotFound {
            return nil
        }
        try Self.check(status)
        return try Self.session(in: item)
    }

    func save(_ session: AuthSession) throws {
        try delete()
        var item = baseQuery
        item[kSecValueData as String] = try JSONEncoder().encode(session)
        item[kSecAttrAccessible as String] = kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
        try Self.check(SecItemAdd(item as CFDictionary, nil))
    }

    func delete() throws {
        let status = SecItemDelete(baseQuery as CFDictionary)
        if status == errSecItemNotFound {
            return
        }
        try Self.check(status)
    }

    private var baseQuery: [String: Any] {
        [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: Self.account,
        ]
    }

    private static func check(_ status: OSStatus) throws {
        guard status == errSecSuccess else {
            throw KeychainError.failed(status: status)
        }
    }

    private static func session(in item: CFTypeRef?) throws -> AuthSession? {
        guard let data = item as? Data else {
            return nil
        }
        return try JSONDecoder().decode(AuthSession.self, from: data)
    }
}
