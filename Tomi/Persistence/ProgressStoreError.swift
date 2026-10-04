/// Why saved data could not be used.
nonisolated enum ProgressStoreError: Error, Equatable {
    /// The store could not be opened, so nothing can be read from it or written to it.
    case unavailable
}
