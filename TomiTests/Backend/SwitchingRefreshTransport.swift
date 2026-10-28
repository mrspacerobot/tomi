import Foundation

@testable import Tomi

/// Changes the saved session while a refresh is in flight.
struct SwitchingRefreshTransport: HTTPTransport {
    let store: InMemoryTokenStore
    let replacement: AuthSession
    let status: Int
    let body: Data

    func send(_ request: URLRequest) async throws -> (Data, HTTPURLResponse) {
        try store.save(replacement)
        let response = HTTPURLResponse(url: request.url!, statusCode: status, httpVersion: nil, headerFields: nil)!
        return (body, response)
    }
}
