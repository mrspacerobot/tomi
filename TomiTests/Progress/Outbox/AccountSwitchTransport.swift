import Foundation
import Synchronization

@testable import Tomi

final class AccountSwitchTransport: HTTPTransport {
    let auth: SwitchingAccountAuth
    private let recorded = Mutex<[URLRequest]>([])

    init(auth: SwitchingAccountAuth) { self.auth = auth }
    var requests: [URLRequest] { recorded.withLock { $0 } }

    func send(_ request: URLRequest) async throws -> (Data, HTTPURLResponse) {
        let count = recorded.withLock { requests in
            requests.append(request)
            return requests.count
        }
        if count == 1 { auth.switchTo("cook-b") }
        var status = 200
        if count == 1 { status = 401 }
        let response = HTTPURLResponse(url: request.url!, statusCode: status, httpVersion: nil, headerFields: nil)!
        return (Data(), response)
    }
}
