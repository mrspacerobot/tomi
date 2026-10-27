extension FakeTomiAPIConfiguration {
    /// The fake server's behaviour the launch arguments ask for.
    nonisolated init(arguments: [String]) {
        self.init(
            suggestionsNothing: arguments.contains(BackendLaunchOptions.fakeNoSuggestionsArgument),
            guidedCooking: arguments.contains(BackendLaunchOptions.fakeGuidedArgument),
            profileRefreshFails: arguments.contains(BackendLaunchOptions.fakeProfileRefreshFailsArgument),
            profileRefreshChanges: arguments.contains(BackendLaunchOptions.fakeProfileRefreshChangesArgument),
            profileRefreshWaits: arguments.contains(BackendLaunchOptions.fakeProfileRefreshWaitsArgument),
            progressServer: FakeProgressServer(arguments: arguments)
        )
    }
}
