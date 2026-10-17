import Foundation
import TomiCore

/// Calls `POST {SUPABASE_URL}/auth/v1/token?grant_type=…` with the publishable key, as Supabase Auth expects.
nonisolated struct SupabaseTokenClient: Sendable {
    static let tokenPath = "auth/v1/token"
    static let grantTypeQuery = "grant_type"

    let supabaseURL: URL
    let publishableKey: String
    let transport: any HTTPTransport

    func session(for grant: SupabaseGrant, at now: Date) async throws -> AuthSession {
        let (data, response) = try await send(request(for: grant))
        guard (200..<300).contains(response.statusCode) else {
            throw BackendError.server(status: response.statusCode, Self.error(in: data))
        }
        guard let answer = try? JSONDecoder().decode(SupabaseTokenResponse.self, from: data) else {
            throw BackendError.unreadableResponse(status: response.statusCode)
        }
        return answer.session(receivedAt: now)
    }

    func request(for grant: SupabaseGrant) throws -> URLRequest {
        let query = URLQueryItem(name: Self.grantTypeQuery, value: grant.grantType)
        var request = URLRequest(url: supabaseURL.appending(path: Self.tokenPath).appending(queryItems: [query]))
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue(publishableKey, forHTTPHeaderField: HTTPHeader.apiKey)
        request.setValue(HTTPHeader.json, forHTTPHeaderField: HTTPHeader.contentType)
        request.httpBody = try JSONSerialization.data(withJSONObject: grant.body, options: [.sortedKeys])
        return request
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
