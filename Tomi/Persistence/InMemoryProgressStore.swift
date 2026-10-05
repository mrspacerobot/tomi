import Foundation
import TomiCore

/// A store that keeps everything in memory and forgets it when it goes, for previews and tests.
/// It reads the cook log by the same rule as the store on the phone, so a test sees the same order.
final class InMemoryProgressStore: ProgressStore {
    private var savedProfile = CookProfile()
    private var entries: [CookEntry] = []
    private var bookmark: ActiveLesson?

    func profile() throws -> CookProfile {
        savedProfile
    }

    func saveProfile(_ profile: CookProfile, at moment: Date) throws {
        savedProfile = profile
    }

    func cookLog() throws -> [CookEntry] {
        entries.map { SavedCookEntry($0) }.cookLog
    }

    func add(_ entry: CookEntry) throws {
        entries.append(entry)
    }

    func activeLesson() throws -> ActiveLesson? {
        bookmark
    }

    func saveActiveLesson(_ lesson: ActiveLesson, at moment: Date) throws {
        bookmark = lesson
    }

    func clearActiveLesson() throws {
        bookmark = nil
    }
}
