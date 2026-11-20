import Foundation

/// Answers every request to the fake photo host with the bundled dish photo, and leaves all other requests alone.
/// Registered in fake launches only, so a fake card's photo loads the way a real one does, without the network.
nonisolated final class FakeDishPhotoProtocol: URLProtocol {
    override static func canInit(with request: URLRequest) -> Bool {
        request.url?.host() == FakeDishPhoto.host
    }

    override static func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }

    override func startLoading() {
        guard let url = request.url, let data = FakeDishPhoto.data(), let response = Self.response(for: url) else {
            client?.urlProtocol(self, didFailWithError: URLError(.fileDoesNotExist))
            return
        }
        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        client?.urlProtocol(self, didLoad: data)
        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}

    private static func response(for url: URL) -> HTTPURLResponse? {
        HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: ["Content-Type": "image/webp"])
    }
}
