import Foundation
import TomiCore

@testable import Tomi

extension HeldProgressAPI: TomiAPI {
    func options() async throws -> LibraryOptions { throw BackendError.notConfigured }
    func profile() async throws -> ProfileEnvelope { throw BackendError.notConfigured }
    func saveProfile(_ patch: ProfilePatch) async throws -> ProfileEnvelope { throw BackendError.notConfigured }
    func scan(jpeg: Data) async throws -> ScanResult { throw BackendError.notConfigured }
    func resolve(_ labels: [String]) async throws -> ResolveResponse { throw BackendError.notConfigured }
    func suggestions(_ request: SuggestionsRequest) async throws -> SuggestionsResponse {
        throw BackendError.notConfigured
    }
    func sendCookEntry(_ request: CookEntryRequest) async throws -> CookEntryResponse {
        throw BackendError.notConfigured
    }
    func sendCookEntry(_ request: CookEntryRequest, for account: String) async throws -> CookEntryResponse {
        throw BackendError.notConfigured
    }
    func answerQuiz(_ pick: QuizPick) async throws -> QuizVerdict { throw BackendError.notConfigured }
}
