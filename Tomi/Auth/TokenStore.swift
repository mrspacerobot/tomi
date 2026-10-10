/// Where the cook's session is kept between launches. The real one is the Keychain; tests keep it in memory.
nonisolated protocol TokenStore: Sendable {
    func load() throws -> AuthSession?
    func save(_ session: AuthSession) throws
    func delete() throws
}
