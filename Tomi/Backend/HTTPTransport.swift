import Foundation

/// Sends one request and hands back the body and the response. URLSession in the app; a stub in unit tests,
/// so the client's handling of status codes and tokens is tested without a network.
nonisolated protocol HTTPTransport: Sendable {
    func send(_ request: URLRequest) async throws -> (Data, HTTPURLResponse)
}
