import Foundation
import TomiCore

/// Tomi's server over the network.
nonisolated struct URLSessionTomiAPI: TomiAPI {
    let client: APIClient

    func options() async throws -> LibraryOptions {
        try await client.value(LibraryOptions.self, for: .options)
    }

    func profile() async throws -> ProfileEnvelope {
        try await client.value(ProfileEnvelope.self, for: .profile)
    }

    func saveProfile(_ patch: ProfilePatch) async throws -> ProfileEnvelope {
        try await client.value(ProfileEnvelope.self, for: .saveProfile(patch))
    }

    func scan(jpeg: Data) async throws -> ScanResult {
        try await client.value(ScanResult.self, for: .scan(jpeg: jpeg))
    }

    func resolve(_ labels: [String]) async throws -> ResolveResponse {
        let request = try APIRequest.resolve.sending(ResolveRequest(labels: labels))
        return try await client.value(ResolveResponse.self, for: request)
    }

    func suggestions(_ request: SuggestionsRequest) async throws -> SuggestionsResponse {
        try await client.value(SuggestionsResponse.self, for: try APIRequest.suggestions.sending(request))
    }

    /// An answer to another question than the one asked is refused, never shown.
    func answerQuiz(_ pick: QuizPick) async throws -> QuizVerdict {
        let verdict = try await client.value(QuizVerdict.self, for: try APIRequest.quizAnswers.sending(pick))
        guard verdict.answers(pick) else {
            throw BackendError.unreadableResponse(status: 200)
        }
        return verdict
    }
}
