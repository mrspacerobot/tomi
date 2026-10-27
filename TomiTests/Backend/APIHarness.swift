import Foundation

@testable import Tomi

/// The real client with a stub transport and sign-in, so a test sees every request and no call reaches a network.
struct APIHarness {
    static let base = URL(string: "https://api.example.test")!

    let api: URLSessionTomiAPI
    let transport: StubTransport
    let auth: StubAuth

    init(_ answers: [StubTransport.Answer]) {
        transport = StubTransport(answers)
        auth = StubAuth()
        var client = APIClient(baseURL: Self.base, auth: auth, transport: transport)
        client.languages = ["fr-CH", "en"]
        api = URLSessionTomiAPI(client: client)
    }
}
