import Foundation
import TomiCore

/// Tomi's server for previews and UI tests. It answers from the bundled library and keeps the profile in memory.
/// It imitates the server's refusals the app must handle: a stale version, and a removed restriction without the
/// cook's confirmation. It never touches the network.
actor FakeTomiAPI: TomiAPI {
    static let profileSchemaVersion = 2

    private let data: FakeServerData
    private let configuration: FakeTomiAPIConfiguration
    private var profileReadCount = 0
    private var pendingProfile: CheckedContinuation<ProfileEnvelope, Never>?
    private var envelope: ProfileEnvelope

    /// The fake cook's profile starts as given: a new cook by default.
    init(
        library: any LessonLibrary,
        profile: CookProfile = CookProfile(),
        configuration: FakeTomiAPIConfiguration = FakeTomiAPIConfiguration()
    ) {
        data = FakeServerData(library: library)
        envelope = ProfileEnvelope(version: 0, schemaVersion: Self.profileSchemaVersion, profile: profile)
        self.configuration = configuration
    }

    func options() async throws -> LibraryOptions {
        data.options
    }

    func profile() async throws -> ProfileEnvelope {
        profileReadCount += 1
        if profileReadCount > 1 && configuration.profileRefreshWaits { return await waitForProfile() }
        if profileReadCount > 1 && configuration.profileRefreshFails { throw BackendError.notSignedIn }
        if profileReadCount > 1 && configuration.profileRefreshChanges { return changedProfile }
        if profileReadCount > 2 && configuration.profileRefreshChangesLate { return changedProfile }
        return envelope
    }

    private var changedProfile: ProfileEnvelope {
        var changed = envelope.profile
        changed.avoid.insert("fake-refresh-change")
        return ProfileEnvelope(version: envelope.version, schemaVersion: Self.profileSchemaVersion, profile: changed)
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
        releasePendingProfile()
        return data.scan()
    }

    private func waitForProfile() async -> ProfileEnvelope {
        await withCheckedContinuation { pendingProfile = $0 }
    }

    private func releasePendingProfile() {
        guard let pendingProfile else { return }
        self.pendingProfile = nil
        pendingProfile.resume(returning: envelope)
    }

    func resolve(_ labels: [String]) async throws -> ResolveResponse {
        ResolveResponse(results: labels.map(data.resolved))
    }

    func suggestions(_ request: SuggestionsRequest) async throws -> SuggestionsResponse {
        if configuration.suggestionsNothing {
            return SuggestionsResponse()
        }
        if configuration.guidedCooking { return try data.guidedSuggestion(for: envelope.profile) }
        return try data.suggestions(for: envelope.profile)
    }
}
