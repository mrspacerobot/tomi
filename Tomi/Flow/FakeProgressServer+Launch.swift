extension FakeProgressServer {
    /// The fixture and the offline switch the launch arguments ask for. A new cook unless told otherwise.
    nonisolated init(arguments: [String]) {
        if arguments.contains(BackendLaunchOptions.fakeProgressReturningArgument) {
            fixture = .returning
        }
        isOffline = arguments.contains(BackendLaunchOptions.fakeCookEntriesOfflineArgument)
    }
}
