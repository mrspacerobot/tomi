import Foundation

extension KnownState {
    /// Writes the profile, every cook and the server's last snapshot into a store, which should be empty.
    /// The snapshot is the fake server's returning cook: the server, not the phone, says what the cooks are worth.
    func write(to store: any ProgressStore) throws {
        let firstEvening = Self.evening(ofDay: 0) ?? .distantPast
        try store.saveProfile(profile, at: firstEvening)
        for entry in cookLog {
            try store.add(entry)
        }
        try store.saveProgressSnapshot(try FakeProgressFixture.returning.body(), at: firstEvening)
    }
}
