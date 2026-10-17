/// Why the Keychain refused. The status is Security's own code, for the log.
nonisolated enum KeychainError: Error, Equatable {
    case failed(status: Int32)
}
