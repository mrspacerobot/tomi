import Foundation
import TomiCore

/// A store that keeps everything in memory and forgets it when it goes, for previews and tests.
/// It keeps the same plain records as the store on the phone and reads them by the same rules in TomiCore,
/// so a test sees the same log, outbox and snapshot.
final class InMemoryProgressStore: ProgressStore {
    private var savedProfile = CookProfile()
    private var cooks: [SavedCookEntry] = []
    private var snapshots: [SavedProgressSnapshot] = []

    func profile() throws -> CookProfile {
        savedProfile
    }

    func saveProfile(_ profile: CookProfile, at moment: Date) throws {
        savedProfile = profile
    }

    func cookLog() throws -> [CookEntry] {
        cooks.cookLog
    }

    func add(_ entry: CookEntry) throws {
        cooks.append(SavedCookEntry(entry))
    }

    func pendingCookEntries(for account: String) throws -> [CookEntry] {
        cooks.pendingCookEntries(for: account)
    }

    func forgetCookEntries(ids: Set<UUID>) throws {
        cooks.removeAll { $0.isCopy(ofOneOf: ids) }
    }

    func markCookEntryRefused(id: UUID, code: CookEntryProblem) throws {
        for index in cooks.indices where cooks[index].isCopy(ofOneOf: [id]) {
            cooks[index].refusedCode = code.rawValue
        }
    }

    func progressSnapshot() throws -> ProgressSnapshot? {
        snapshots.lastSnapshot
    }

    func progressSnapshot(for account: String) throws -> ProgressSnapshot? {
        snapshots.lastSnapshot(for: account)
    }

    func saveProgressSnapshot(_ body: Data, at moment: Date) throws {
        var saved = SavedProgressSnapshot()
        saved.stableID = UUID()
        saved.receivedAt = moment
        saved.body = body
        snapshots = [saved]
    }

    func saveProgressSnapshot(_ body: Data, at moment: Date, for account: String) throws {
        var saved = SavedProgressSnapshot()
        saved.stableID = UUID()
        saved.receivedAt = moment
        saved.body = body
        saved.account = account
        snapshots.removeAll { $0.account == account }
        snapshots.append(saved)
    }
}
