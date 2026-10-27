import Foundation

nonisolated extension AuthSession {
    /// The account the access token belongs to: the `sub` claim of the token, which is the Supabase user id.
    /// The token is only read here, never checked: the server checks it. Nil when it cannot be read.
    var accountID: String? {
        let parts = accessToken.split(separator: ".")
        guard parts.count == 3 else {
            return nil
        }
        guard let payload = Self.decode(String(parts[1])) else {
            return nil
        }
        return try? JSONDecoder().decode(Claims.self, from: payload).sub
    }

    private struct Claims: Decodable {
        let sub: String
    }

    private static func decode(_ base64URL: String) -> Data? {
        var base64 = base64URL.replacing("-", with: "+").replacing("_", with: "/")
        while base64.count % 4 != 0 {
            base64.append("=")
        }
        return Data(base64Encoded: base64)
    }
}
