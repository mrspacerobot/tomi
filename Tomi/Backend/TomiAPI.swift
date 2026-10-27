import Foundation
import TomiCore

/// Every call the app makes to Tomi's server. The server owns the food lists, the profile,
/// fridge scans and tonight's special; the app shows what it is sent and sends back what the cook picked.
/// `URLSessionTomiAPI` talks to the server; `FakeTomiAPI` serves previews and UI tests.
nonisolated protocol TomiAPI: Sendable {
    /// The lists the cook picks from, in the cook's language. Needs no sign-in.
    func options() async throws -> LibraryOptions
    func profile() async throws -> ProfileEnvelope
    /// Sends only what changed. Throws `version_conflict` with the profile as it is now,
    /// or `weakens_restrictions` unless the cook confirmed the removal.
    func saveProfile(_ patch: ProfilePatch) async throws -> ProfileEnvelope
    /// Sends a JPEG of the fridge. Proof of concept: the server keeps every photo and nothing asks the cook yet.
    func scan(jpeg: Data) async throws -> ScanResult
    func resolve(_ labels: [String]) async throws -> ResolveResponse
    func suggestions(_ request: SuggestionsRequest) async throws -> SuggestionsResponse
    /// Sends one batch of the outbox. The server answers each cook in the place it was sent, with the snapshot
    /// after the batch, kept as it was sent. A batch the server cannot read is `422 invalid_request`: every cook
    /// stays to be sent again.
    func sendCookEntries(_ request: CookEntriesRequest) async throws -> CookEntriesResponse
    /// The cook's progress, worked out by the server, with the week in progress judged by this calendar.
    func progress(_ calendar: CalendarContext) async throws -> ProgressSnapshot
}
