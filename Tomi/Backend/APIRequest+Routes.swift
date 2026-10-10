import Foundation
import TomiCore

/// The server's routes, written once.
extension APIRequest {
    nonisolated static let options = publicRequest(.get, "v1/options")
    nonisolated static let profile = APIRequest(.get, "v1/profile")
    nonisolated static let consents = APIRequest(.get, "v1/consents")
    nonisolated static let resolve = APIRequest(.post, "v1/ingredients/resolve")
    nonisolated static let specials = APIRequest(.post, "v1/specials")

    nonisolated static func saveProfile(_ patch: ProfilePatch) throws -> APIRequest {
        var request = APIRequest(.patch, "v1/profile")
        request.body = try patch.body()
        return request
    }

    nonisolated static func consent(_ purpose: ConsentPurpose, _ method: HTTPMethod) -> APIRequest {
        APIRequest(method, "v1/consents/" + purpose.rawValue)
    }

    nonisolated static func scan(jpeg: Data) -> APIRequest {
        var request = APIRequest(.post, "v1/scans")
        request.body = jpeg
        request.contentType = HTTPHeader.jpeg
        return request
    }

    nonisolated private static func publicRequest(_ method: HTTPMethod, _ path: String) -> APIRequest {
        var request = APIRequest(method, path)
        request.isAuthenticated = false
        return request
    }
}
