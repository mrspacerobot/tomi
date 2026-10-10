import Foundation
import Testing
import TomiCore

@testable import Tomi

/// How every call reaches the server: address, language, token, one renewal on 401, and the error body.
@Suite struct APIClientTests {
    let base = URL(string: "https://api.example.test")!

    func make(_ answers: [StubTransport.Answer]) -> (URLSessionTomiAPI, StubTransport, StubAuth) {
        let transport = StubTransport(answers)
        let auth = StubAuth()
        var client = APIClient(baseURL: base, auth: auth, transport: transport)
        client.languages = ["fr-CH", "en"]
        return (URLSessionTomiAPI(client: client), transport, auth)
    }

    @Test func theOptionsAreAskedInTheCooksLanguageWithoutAToken() async throws {
        let (api, transport, _) = make([.init(status: 200, body: #"{"libraryVersion": 1, "diets": [], "avoidItems": [], "cuisines": [], "equipment": [], "experience": [], "units": [], "ingredients": [], "courses": []}"#)])
        _ = try await api.options()
        let request = try #require(transport.requests.first)
        #expect(request.url?.absoluteString == "https://api.example.test/v1/options")
        #expect(request.value(forHTTPHeaderField: "Accept-Language") == "fr-CH, en")
        #expect(request.value(forHTTPHeaderField: "Authorization") == nil)
    }

    @Test func aSignedInCallCarriesTheBearerToken() async throws {
        let (api, transport, _) = make([.init(status: 200, body: "[]")])
        _ = try await api.consents()
        #expect(transport.requests.first?.value(forHTTPHeaderField: "Authorization") == "Bearer old")
    }

    @Test func a401RenewsTheTokenOnceAndTriesAgain() async throws {
        let (api, transport, auth) = make([.init(status: 401, body: ""), .init(status: 200, body: "[]")])
        _ = try await api.consents()
        #expect(auth.renewalCount == 1)
        #expect(transport.requests.map { $0.value(forHTTPHeaderField: "Authorization") } == ["Bearer old", "Bearer new"])
    }

    @Test func anErrorBodyBecomesTheServersError() async {
        let body = #"{"error": {"code": "ai_unavailable", "message": "Type instead."}}"#
        let (api, _, _) = make([.init(status: 503, body: body)])
        await #expect(throws: BackendError.server(status: 503, APIError(codeName: "ai_unavailable", message: "Type instead."))) {
            try await api.scan(jpeg: Data([1]))
        }
    }

    @Test func aPhotoIsSentAsJPEGBytes() async throws {
        let scan = #"{"scanId": "s", "kept": false, "items": []}"#
        let (api, transport, _) = make([.init(status: 200, body: scan)])
        _ = try await api.scan(jpeg: Data([1, 2]))
        let request = try #require(transport.requests.first)
        #expect(request.httpMethod == "POST")
        #expect(request.value(forHTTPHeaderField: "Content-Type") == "image/jpeg")
        #expect(request.httpBody == Data([1, 2]))
    }

    @Test func aConsentIsGivenForTheVersionShown() async throws {
        let (api, transport, _) = make([.init(status: 204, body: "")])
        try await api.agree(to: .photoDataset, version: 1)
        let request = try #require(transport.requests.first)
        #expect(request.httpMethod == "PUT")
        #expect(request.url?.path() == "/v1/consents/photo-dataset")
        #expect(request.httpBody == Data(#"{"version":1}"#.utf8))
    }

    @Test func noAnswerIsUnreachable() async {
        let (api, _, _) = make([])
        await #expect(throws: BackendError.unreachable) {
            try await api.consents()
        }
    }
}
