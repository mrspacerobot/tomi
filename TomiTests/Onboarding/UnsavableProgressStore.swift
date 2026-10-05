import Foundation
import TomiCore

@testable import Tomi

/// A store that can be read but takes no writes, to reach what a cook sees when an answer cannot be saved.
struct UnsavableProgressStore: ProgressStore {
    func profile() throws -> CookProfile { CookProfile() }
    func saveProfile(_ profile: CookProfile, at moment: Date) throws { throw ProgressStoreError.unavailable }
    func cookLog() throws -> [CookEntry] { [] }
    func add(_ entry: CookEntry) throws { throw ProgressStoreError.unavailable }
    func activeLesson() throws -> ActiveLesson? { nil }
    func saveActiveLesson(_ lesson: ActiveLesson, at moment: Date) throws { throw ProgressStoreError.unavailable }
    func clearActiveLesson() throws { throw ProgressStoreError.unavailable }
}
