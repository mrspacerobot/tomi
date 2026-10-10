import Foundation
import TomiCore

/// Every call the app makes to Tomi's server. The server owns the food lists, the profile, consents,
/// fridge scans and tonight's special; the app shows what it is sent and sends back what the cook picked.
/// `URLSessionTomiAPI` talks to the server; `FakeTomiAPI` serves previews and UI tests.
nonisolated protocol TomiAPI: Sendable {
    /// The lists the cook picks from, in the cook's language. Needs no sign-in.
    func options() async throws -> LibraryOptions
    func profile() async throws -> ProfileEnvelope
    /// Sends only what changed. Throws `version_conflict` with the profile as it is now,
    /// or `weakens_restrictions` unless the cook confirmed the removal.
    func saveProfile(_ patch: ProfilePatch) async throws -> ProfileEnvelope
    func consents() async throws -> [ConsentStatus]
    /// Agrees to the text of this version, which the cook was shown.
    func agree(to purpose: ConsentPurpose, version: Int) async throws
    func withdraw(_ purpose: ConsentPurpose) async throws
    /// Sends a JPEG of the fridge, only after the cook's `photo-scan` consent.
    func scan(jpeg: Data) async throws -> ScanResult
    func resolve(_ labels: [String]) async throws -> ResolveResponse
    func specials(_ request: SpecialsRequest) async throws -> SpecialsResponse
}
