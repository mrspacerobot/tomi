/// Behavior switches for deterministic fake-server flows in previews and UI tests.
nonisolated struct FakeTomiAPIConfiguration {
    let suggestionsNothing: Bool
    let guidedCooking: Bool
    let profileRefreshFails: Bool
    let profileRefreshChanges: Bool
    let profileRefreshWaits: Bool

    init(
        suggestionsNothing: Bool = false,
        guidedCooking: Bool = false,
        profileRefreshFails: Bool = false,
        profileRefreshChanges: Bool = false,
        profileRefreshWaits: Bool = false
    ) {
        self.suggestionsNothing = suggestionsNothing
        self.guidedCooking = guidedCooking
        self.profileRefreshFails = profileRefreshFails
        self.profileRefreshChanges = profileRefreshChanges
        self.profileRefreshWaits = profileRefreshWaits
    }
}
