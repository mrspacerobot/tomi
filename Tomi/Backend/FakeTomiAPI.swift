import Foundation
import TomiCore

/// Tomi's server for previews and UI tests. It answers from the bundled library and keeps the profile and
/// consents in memory. It imitates the server's refusals the app must handle: a stale version, a removed
/// restriction without the cook's confirmation, and a scan without consent. It never touches the network.
actor FakeTomiAPI: TomiAPI {
    static let profileSchemaVersion = 1

    private let data: FakeServerData
    private let offersNothing: Bool
    private var envelope: ProfileEnvelope
    private var agreed: Set<ConsentPurpose> = []

    /// The fake cook's profile starts as given: a new cook by default.
    init(library: any LessonLibrary, profile: CookProfile = CookProfile(), offersNothing: Bool = false) {
        data = FakeServerData(library: library)
        envelope = ProfileEnvelope(version: 0, schemaVersion: Self.profileSchemaVersion, profile: profile)
        self.offersNothing = offersNothing
    }

    func options() async throws -> LibraryOptions {
        data.options
    }

    func profile() async throws -> ProfileEnvelope {
        envelope
    }

    func saveProfile(_ patch: ProfilePatch) async throws -> ProfileEnvelope {
        try FakeProfileRules(stored: envelope).check(patch)
        envelope = ProfileEnvelope(
            version: envelope.version + 1,
            schemaVersion: Self.profileSchemaVersion,
            profile: patch.after
        )
        return envelope
    }

    func consents() async throws -> [ConsentStatus] {
        ConsentPurpose.allCases.map { purpose in
            ConsentStatus(purpose: purpose, currentVersion: ConsentText.version, agreed: agreed.contains(purpose))
        }
    }

    func agree(to purpose: ConsentPurpose, version: Int) async throws {
        agreed.insert(purpose)
    }

    func withdraw(_ purpose: ConsentPurpose) async throws {
        agreed.remove(purpose)
    }

    func scan(jpeg: Data) async throws -> ScanResult {
        guard agreed.contains(.photoScan) else {
            throw FakeProfileRules.refusal(.consentRequired, status: 403)
        }
        return data.scan(keepingPhoto: agreed.contains(.photoDataset))
    }

    func resolve(_ labels: [String]) async throws -> ResolveResponse {
        ResolveResponse(results: labels.map(data.resolved))
    }

    func specials(_ request: SpecialsRequest) async throws -> SpecialsResponse {
        if offersNothing {
            return SpecialsResponse()
        }
        return data.specials(for: envelope.profile)
    }
}
