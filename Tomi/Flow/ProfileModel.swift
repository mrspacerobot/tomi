import Foundation
import TomiCore

/// The server's lists and the cook's profile, as every screen that asks or shows an answer sees them.
@Observable
final class ProfileModel {
    private(set) var options: LibraryOptions?
    private(set) var envelope: ProfileEnvelope?
    private let api: any TomiAPI
    private let cache: ProfileCache

    init(api: any TomiAPI, store: any ProgressStore) {
        self.api = api
        cache = ProfileCache(store: store)
    }

    /// The profile as the server last sent it, or the defaults before it has.
    var profile: CookProfile {
        guard let envelope else {
            return CookProfile()
        }
        return envelope.profile
    }

    func load() async throws {
        options = try await api.options()
        try accept(try await api.profile())
    }

    /// Sends the cook's answers. A stale version is answered by making the change again on the newer profile;
    /// a removed restriction is sent only once the cook has confirmed it on screen.
    func save(_ answers: CookProfile, confirmedWeaker: Bool) async throws -> ProfileSaveResult {
        var patch = ProfilePatch(version: try currentVersion(), before: profile, after: answers)
        patch.allowsWeakerRestrictions = confirmedWeaker
        do {
            try accept(try await send(patch))
            return .saved
        } catch let error as BackendError where error.code == .weakensRestrictions {
            return .needsConfirmation
        }
    }

    private func send(_ patch: ProfilePatch) async throws -> ProfileEnvelope {
        do {
            return try await api.saveProfile(patch)
        } catch BackendError.server(_, let error) where error.code == .versionConflict {
            guard let current = error.currentProfile else {
                throw BackendError.server(status: 409, error)
            }
            var again = try patch.rebased(on: current)
            again.allowsWeakerRestrictions = patch.allowsWeakerRestrictions
            return try await api.saveProfile(again)
        }
    }

    private func currentVersion() throws -> Int {
        guard let envelope else {
            throw BackendError.notSignedIn
        }
        return envelope.version
    }

    private func accept(_ fresh: ProfileEnvelope) throws {
        envelope = fresh
        try cache.keep(fresh.profile, at: .now)
    }
}
