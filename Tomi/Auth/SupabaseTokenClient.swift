import Foundation
import TomiCore

/// Calls `POST {SUPABASE_URL}/auth/v1/token?grant_type=…` with the publishable key, as Supabase Auth expects.
nonisolated struct SupabaseTokenClient: Sendable {
    static let tokenPath = "auth/v1/token"
    static let signupPath = "auth/v1/signup"
    static let recoveryPath = "auth/v1/recover"
    static let grantTypeQuery = "grant_type"

    let supabaseURL: URL
    let publishableKey: String
    let transport: any HTTPTransport

    func session(for grant: SupabaseGrant, at now: Date) async throws -> AuthSession {
        let data = try await acceptedBody(for: request(for: grant))
        guard let answer = try? JSONDecoder().decode(SupabaseTokenResponse.self, from: data) else {
            throw BackendError.unreadableResponse(status: 200)
        }
        return answer.session(receivedAt: now)
    }

    func createAccount(email: String, password: String, at now: Date) async throws -> SupabaseSignUpResult {
        let request = try request(path: Self.signupPath, query: [], body: ["email": email, "password": password])
        let data = try await acceptedBody(for: request)
        guard let answer = try? JSONDecoder().decode(SupabaseSignUpResponse.self, from: data) else {
            throw BackendError.unreadableResponse(status: 200)
        }
        return try answer.result(receivedAt: now)
    }

    func sendPasswordReset(to email: String) async throws {
        let request = try request(path: Self.recoveryPath, query: [], body: ["email": email])
        _ = try await acceptedBody(for: request)
    }

    func request(for grant: SupabaseGrant) throws -> URLRequest {
        let query = URLQueryItem(name: Self.grantTypeQuery, value: grant.grantType)
        return try request(path: Self.tokenPath, query: [query], body: grant.body)
    }

    private func request(path: String, query: [URLQueryItem], body: [String: String]) throws -> URLRequest {
        var url = supabaseURL.appending(path: path)
        if !query.isEmpty {
            url = url.appending(queryItems: query)
        }
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue(publishableKey, forHTTPHeaderField: HTTPHeader.apiKey)
        request.setValue(HTTPHeader.json, forHTTPHeaderField: HTTPHeader.contentType)
        request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [.sortedKeys])
        return request
    }

    private func acceptedBody(for request: URLRequest) async throws -> Data {
        let (data, response) = try await send(request)
        guard (200..<300).contains(response.statusCode) else {
            throw BackendError.server(status: response.statusCode, Self.error(in: data))
        }
        return data
    }

    private func send(_ request: URLRequest) async throws -> (Data, HTTPURLResponse) {
        do {
            return try await transport.send(request)
        } catch {
            throw BackendError.unreachable
        }
    }

    /// Supabase's own errors have another layout than Tomi's; only the status matters to the app.
    private static func error(in data: Data) -> APIError {
        guard let message = String(bytes: data, encoding: .utf8) else {
            return APIError(codeName: APIErrorCode.unauthenticated.rawValue, message: "")
        }
        return APIError(codeName: APIErrorCode.unauthenticated.rawValue, message: message)
    }
}
