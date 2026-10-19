import Foundation
import TomiCore

/// Tomi's server for previews and UI tests. It answers from the bundled library and keeps the profile in memory.
/// It imitates the server's refusals the app must handle: a stale version, and a removed restriction without the
/// cook's confirmation. It never touches the network.
actor FakeTomiAPI: TomiAPI {
    static let profileSchemaVersion = 2

    private let data: FakeServerData
    private let suggestionsNothing: Bool
    private var envelope: ProfileEnvelope

    /// The fake cook's profile starts as given: a new cook by default.
    init(library: any LessonLibrary, profile: CookProfile = CookProfile(), suggestionsNothing: Bool = false) {
        data = FakeServerData(library: library)
        envelope = ProfileEnvelope(version: 0, schemaVersion: Self.profileSchemaVersion, profile: profile)
        self.suggestionsNothing = suggestionsNothing
    }

    func options() async throws -> LibraryOptions {
        data.options
    }

    func profile() async throws -> ProfileEnvelope {
        envelope
    }

    func saveProfile(_ patch: ProfilePatch) async throws -> ProfileEnvelope {
        try FakeProfileRules(stored: envelope, options: data.options).check(patch)
        envelope = ProfileEnvelope(
            version: envelope.version + 1,
            schemaVersion: Self.profileSchemaVersion,
            profile: patch.after
        )
        return envelope
    }

    func scan(jpeg: Data) async throws -> ScanResult {
        data.scan()
    }

    func resolve(_ labels: [String]) async throws -> ResolveResponse {
        ResolveResponse(results: labels.map(data.resolved))
    }

    func specials(_ request: SpecialsRequest) async throws -> SpecialsResponse {
        if suggestionsNothing {
            return SpecialsResponse()
        }
        return try data.specials(for: envelope.profile)
    }
}
