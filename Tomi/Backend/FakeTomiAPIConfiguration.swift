/// Behavior switches for deterministic fake-server flows in previews and UI tests.
nonisolated struct FakeTomiAPIConfiguration: Equatable {
    let suggestionsNothing: Bool
    let guidedCooking: Bool
    let profileRefreshFails: Bool
    let profileRefreshChanges: Bool
    let profileRefreshWaits: Bool
    /// How the progress routes answer: which fixture snapshot, or failing as if offline.
    var progressServer: FakeProgressServer

    init(
        suggestionsNothing: Bool = false,
        guidedCooking: Bool = false,
        profileRefreshFails: Bool = false,
        profileRefreshChanges: Bool = false,
        profileRefreshWaits: Bool = false,
        progressServer: FakeProgressServer = FakeProgressServer()
    ) {
        self.suggestionsNothing = suggestionsNothing
        self.guidedCooking = guidedCooking
        self.profileRefreshFails = profileRefreshFails
        self.profileRefreshChanges = profileRefreshChanges
        self.profileRefreshWaits = profileRefreshWaits
        self.progressServer = progressServer
    }
}
