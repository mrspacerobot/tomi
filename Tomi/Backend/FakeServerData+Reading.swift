import Foundation
import OSLog
import TomiCore

nonisolated extension FakeServerData {
    static func readOptions() -> LibraryOptions {
        do {
            let data = try FakeFixtureFile.data(named: "fake-options")
            return try JSONDecoder().decode(LibraryOptions.self, from: data)
        } catch {
            logger.error("The fake options could not be read: \(String(describing: error), privacy: .public)")
            return LibraryOptions()
        }
    }

    /// Each suggestion of the fixture as its own JSON, so the struct stays Sendable.
    static func readSuggestionFixtures() -> [Data] {
        do {
            let data = try FakeFixtureFile.data(named: "fake-suggestions")
            let offers = try JSONSerialization.jsonObject(with: data) as? [Any] ?? []
            return try offers.map { try JSONSerialization.data(withJSONObject: $0) }
        } catch {
            logger.error("The fake suggestions could not be read: \(String(describing: error), privacy: .public)")
            return []
        }
    }

    /// One offer of the fixture, checked for the cook's diet and avoid list.
    static func offer(_ data: Data, checkedFor profile: CookProfile) throws -> [String: Any] {
        guard var offer = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            throw CocoaError(.coderReadCorrupt)
        }
        var checked: [String: Any] = ["avoid": profile.avoid.map(\.rawValue).sorted()]
        checked["diet"] = profile.diet?.rawValue ?? NSNull()
        offer["checked"] = checked
        return offer
    }
}
