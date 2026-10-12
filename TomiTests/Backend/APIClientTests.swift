import Foundation
import Testing
import TomiCore

@testable import Tomi

/// How every call reaches the server: address, language, token, one renewal on 401, and the error body.
@Suite struct APIClientTests {
    let base = URL(string: "https://api.example.test")!

    /// The client under test with the transport and sign-in it talks to.
    struct Harness {
        let api: URLSessionTomiAPI
        let transport: StubTransport
        let auth: StubAuth
    }

    func make(_ answers: [StubTransport.Answer]) -> Harness {
        let transport = StubTransport(answers)
        let auth = StubAuth()
        var client = APIClient(baseURL: base, auth: auth, transport: transport)
        client.languages = ["fr-CH", "en"]
        return Harness(api: URLSessionTomiAPI(client: client), transport: transport, auth: auth)
    }

    @Test func theOptionsAreAskedInTheCooksLanguageWithoutAToken() async throws {
        let options =
            #"{"libraryVersion": 1, "diets": [], "avoidItems": [], "cuisines": [], "equipment": [], "#
            + #""experience": [], "units": [], "ingredients": [], "courses": []}"#
        let harness = make([.init(status: 200, body: options)])
        _ = try await harness.api.options()
        let request = try #require(harness.transport.requests.first)
        #expect(request.url?.absoluteString == "https://api.example.test/v1/options")
        #expect(request.value(forHTTPHeaderField: "Accept-Language") == "fr-CH, en")
        #expect(request.value(forHTTPHeaderField: "Authorization") == nil)
    }

    @Test func aSignedInCallCarriesTheBearerToken() async throws {
        let harness = make([.init(status: 200, body: "[]")])
        _ = try await harness.api.consents()
        #expect(harness.transport.requests.first?.value(forHTTPHeaderField: "Authorization") == "Bearer old")
    }

    @Test func a401RenewsTheTokenOnceAndTriesAgain() async throws {
        let harness = make([.init(status: 401, body: ""), .init(status: 200, body: "[]")])
        _ = try await harness.api.consents()
        #expect(harness.auth.renewalCount == 1)
        let tokens = harness.transport.requests.map { $0.value(forHTTPHeaderField: "Authorization") }
        #expect(tokens == ["Bearer old", "Bearer new"])
    }

    @Test func anErrorBodyBecomesTheServersError() async {
        let body = #"{"error": {"code": "ai_unavailable", "message": "Type instead."}}"#
        let harness = make([.init(status: 503, body: body)])
        let expected = BackendError.server(status: 503, APIError(codeName: "ai_unavailable", message: "Type instead."))
        await #expect(throws: expected) {
            try await harness.api.scan(jpeg: Data([1]))
        }
    }

    @Test func aPhotoIsSentAsJPEGBytes() async throws {
        let scan = #"{"scanId": "s", "kept": false, "items": []}"#
        let harness = make([.init(status: 200, body: scan)])
        _ = try await harness.api.scan(jpeg: Data([1, 2]))
        let request = try #require(harness.transport.requests.first)
        #expect(request.httpMethod == "POST")
        #expect(request.value(forHTTPHeaderField: "Content-Type") == "image/jpeg")
        #expect(request.httpBody == Data([1, 2]))
    }

    @Test func tonightsLessonIsAskedFromTheSuggestRoute() async throws {
        let answer = #"{"libraryVersion": 1, "rankedBy": "overlap", "special": null, "alternatives": []}"#
        let harness = make([.init(status: 200, body: answer)])
        _ = try await harness.api.specials(SpecialsRequest(ingredients: ["egg"], scanID: nil))
        let request = try #require(harness.transport.requests.first)
        #expect(request.httpMethod == "POST")
        #expect(request.url?.absoluteString == "https://api.example.test/v1/lessons/suggest")
    }

    @Test func aConsentIsGivenForTheVersionShown() async throws {
        let harness = make([.init(status: 204, body: "")])
        try await harness.api.agree(to: .photoDataset, version: 1)
        let request = try #require(harness.transport.requests.first)
        #expect(request.httpMethod == "PUT")
        #expect(request.url?.path() == "/v1/consents/photo-dataset")
        #expect(request.httpBody == Data(#"{"version":1}"#.utf8))
    }

    @Test func noAnswerIsUnreachable() async {
        let harness = make([])
        await #expect(throws: BackendError.unreachable) {
            try await harness.api.consents()
        }
    }
}
