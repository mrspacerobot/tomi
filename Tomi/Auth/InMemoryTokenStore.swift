import Synchronization

/// A token store that forgets everything when it goes, for previews and tests.
nonisolated final class InMemoryTokenStore: TokenStore {
    private let session: Mutex<AuthSession?>

    init(_ session: AuthSession? = nil) {
        self.session = Mutex(session)
    }

    func load() throws -> AuthSession? {
        session.withLock { $0 }
    }

    func save(_ session: AuthSession) throws {
        self.session.withLock { $0 = session }
    }

    func delete() throws {
        session.withLock { $0 = nil }
    }
}
