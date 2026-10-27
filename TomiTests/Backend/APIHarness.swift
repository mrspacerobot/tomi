import Foundation

@testable import Tomi

/// The client under test with the transport and sign-in it talks to.
struct APIHarness {
    static let base = URL(string: "https://api.example.test")!

    let api: URLSessionTomiAPI
    let transport: StubTransport
    let auth: StubAuth

    static func make(_ answers: [StubTransport.Answer]) -> APIHarness {
        let transport = StubTransport(answers)
        let auth = StubAuth()
        var client = APIClient(baseURL: base, auth: auth, transport: transport)
        client.languages = ["fr-CH", "en"]
        return APIHarness(api: URLSessionTomiAPI(client: client), transport: transport, auth: auth)
    }
}
