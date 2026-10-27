import Foundation
import TomiCore

/// The server's routes, written once.
extension APIRequest {
    nonisolated static let options = publicRequest(.get, "v1/options")
    nonisolated static let profile = APIRequest(.get, "v1/profile")
    nonisolated static let resolve = APIRequest(.post, "v1/ingredients/resolve")
    nonisolated static let suggestions = APIRequest(.post, "v1/lessons/suggest")
    nonisolated static let cookEntries = APIRequest(.post, "v1/cook-entries")

    /// The progress of the week in progress by the cook's calendar, as the server asks for it.
    nonisolated static func progress(_ calendar: CalendarContext) -> APIRequest {
        var request = APIRequest(.get, "v1/progress")
        request.query = [
            URLQueryItem(name: CalendarQuery.timeZone, value: calendar.timeZone),
            URLQueryItem(name: CalendarQuery.firstWeekday, value: String(calendar.firstWeekday)),
        ]
        return request
    }

    nonisolated static let quizAnswers = APIRequest(.post, "v1/quiz-answers")

    nonisolated static func saveProfile(_ patch: ProfilePatch) throws -> APIRequest {
        var request = APIRequest(.patch, "v1/profile")
        request.body = try patch.body()
        return request
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
