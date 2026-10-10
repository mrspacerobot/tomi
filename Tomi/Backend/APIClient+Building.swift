import Foundation
import TomiCore

extension APIClient {
    /// The request as it goes over the wire.
    nonisolated func urlRequest(for request: APIRequest, token: String?) -> URLRequest {
        var built = URLRequest(url: baseURL.appending(path: request.path))
        built.httpMethod = request.method.rawValue
        built.setValue(acceptLanguage, forHTTPHeaderField: HTTPHeader.acceptLanguage)
        built.httpBody = request.body
        if request.body != nil {
            built.setValue(request.contentType, forHTTPHeaderField: HTTPHeader.contentType)
        }
        built.setValue(token.map(HTTPHeader.bearer), forHTTPHeaderField: HTTPHeader.authorization)
        return built
    }

    /// The body of a 2xx answer, or the server's error.
    nonisolated static func checked(_ answer: (Data, HTTPURLResponse)) throws -> Data {
        let (data, response) = answer
        if (200..<300).contains(response.statusCode) {
            return data
        }
        guard let error = APIError.decode(from: data) else {
            throw BackendError.unreadableResponse(status: response.statusCode)
        }
        throw BackendError.server(status: response.statusCode, error)
    }

    /// The cook's languages, most wanted first, as the header lists them.
    nonisolated private var acceptLanguage: String {
        languages.prefix(3).joined(separator: ", ")
    }
}
