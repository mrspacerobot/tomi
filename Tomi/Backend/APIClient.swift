import Foundation
import TomiCore

/// Sends `APIRequest`s to Tomi's server: adds the address, the cook's language and the access token,
/// renews the token once when the server answers 401, and turns an error body into `BackendError.server`.
nonisolated struct APIClient: Sendable {
    let baseURL: URL
    let auth: any AuthService
    let transport: any HTTPTransport

    /// The cook's languages in order of preference, so the server names everything in the right one.
    var languages: [String] = Locale.preferredLanguages

    /// The answer body of a call that succeeded.
    func data(for request: APIRequest) async throws -> Data {
        let account = try account(for: request)
        let accessToken = try await token(for: request, renewed: false, account: account)
        let (data, response) = try await send(request, token: accessToken)
        if response.statusCode == 401 && request.isAuthenticated {
            let renewed = try await token(for: request, renewed: true, account: account)
            return try Self.checked(try await send(request, token: renewed))
        }
        return try Self.checked((data, response))
    }

    /// The decoded answer of a call that succeeded.
    func value<Value: Decodable>(_ type: Value.Type, for request: APIRequest) async throws -> Value {
        try await read(request) { try JSONDecoder().decode(type, from: $0) }
    }

    /// The answer of a call that succeeded, read from its body by `reading`.
    func read<Value>(_ request: APIRequest, with reading: (Data) throws -> Value) async throws -> Value {
        let data = try await data(for: request)
        do {
            return try reading(data)
        } catch {
            throw BackendError.unreadableResponse(status: 200)
        }
    }

    private func account(for request: APIRequest) throws -> String? {
        guard request.isAuthenticated else { return nil }
        guard let account = request.account ?? auth.accountID() else { throw BackendError.notSignedIn }
        return account
    }

    private func token(for request: APIRequest, renewed: Bool, account: String?) async throws -> String? {
        guard request.isAuthenticated else {
            return nil
        }
        guard let account else { throw BackendError.notSignedIn }
        return try await auth.accessToken(for: account, renewing: renewed)
    }

    private func send(_ request: APIRequest, token: String?) async throws -> (Data, HTTPURLResponse) {
        do {
            return try await transport.send(urlRequest(for: request, token: token))
        } catch {
            throw BackendError.unreachable
        }
    }
}
