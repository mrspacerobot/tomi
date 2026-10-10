import Foundation
import Synchronization

@testable import Tomi

/// A transport that records every request and answers from a queue, so no test touches the network.
final class StubTransport: HTTPTransport {
    struct Answer: Sendable {
        let status: Int
        let body: String
    }

    private let state = Mutex<(answers: [Answer], requests: [URLRequest])>(([], []))

    init(_ answers: [Answer]) {
        state.withLock { $0.answers = answers }
    }

    var requests: [URLRequest] {
        state.withLock { $0.requests }
    }

    func send(_ request: URLRequest) async throws -> (Data, HTTPURLResponse) {
        let answer = try state.withLock { state in
            state.requests.append(request)
            guard !state.answers.isEmpty else {
                throw URLError(.notConnectedToInternet)
            }
            return state.answers.removeFirst()
        }
        let response = HTTPURLResponse(url: request.url!, statusCode: answer.status, httpVersion: nil, headerFields: nil)!
        return (Data(answer.body.utf8), response)
    }
}
