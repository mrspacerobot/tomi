import Foundation
import TomiCore

@testable import Tomi

/// The routes the uploader never calls. Each fails, so a test that reached one would show it.
/// The conformance is declared here, not on the actor: Xcode 27 otherwise carries the protocol's `nonisolated`
/// onto the actor and its initializer, and refuses to build them.
extension ScriptedProgressAPI: TomiAPI {
    func options() async throws -> LibraryOptions {
        throw BackendError.notConfigured
    }

    func profile() async throws -> ProfileEnvelope {
        throw BackendError.notConfigured
    }

    func saveProfile(_ patch: ProfilePatch) async throws -> ProfileEnvelope {
        throw BackendError.notConfigured
    }

    func scan(jpeg: Data) async throws -> ScanResult {
        throw BackendError.notConfigured
    }

    func resolve(_ labels: [String]) async throws -> ResolveResponse {
        throw BackendError.notConfigured
    }

    func suggestions(_ request: SuggestionsRequest) async throws -> SuggestionsResponse {
        throw BackendError.notConfigured
    }

    func progress(_ calendar: CalendarContext) async throws -> ProgressSnapshot {
        throw BackendError.notConfigured
    }
}
