import Foundation

extension KnownState {
    /// Writes the profile and every cook into a store, which should be empty.
    func write(to store: any ProgressStore) throws {
        try store.saveProfile(profile, at: Self.evening(ofDay: 0) ?? .distantPast)
        for entry in cookLog {
            try store.add(entry)
        }
    }
}
