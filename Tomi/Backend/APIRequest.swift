import Foundation

/// One call to Tomi's server, before the address, the language and the token are added.
nonisolated struct APIRequest: Sendable {
    let method: HTTPMethod
    let path: String
    /// Values of the query, written as given: `APIClient` escapes them for the wire.
    var query: [URLQueryItem] = []
    var body: Data?
    var contentType = HTTPHeader.json
    /// Every call but the options carries the cook's access token.
    var isAuthenticated = true
    /// When present, the request must use this account's credentials, even after a retry.
    var account: String?

    init(_ method: HTTPMethod, _ path: String) {
        self.method = method
        self.path = path
    }

    /// The same call with a JSON body.
    func sending(_ value: some Encodable) throws -> APIRequest {
        var request = self
        request.body = try JSONEncoder().encode(value)
        return request
    }
}
